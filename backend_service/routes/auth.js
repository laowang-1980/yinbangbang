const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const crypto = require('crypto');

// 模拟用户数据库
const users = new Map();

// JWT密钥
const JWT_SECRET = 'your-secret-key-here';

// 生成JWT token
function generateToken(user) {
  return jwt.sign(
    { 
      userId: user.id, 
      phone: user.phone,
      name: user.name 
    },
    JWT_SECRET,
    { expiresIn: '7d' }
  );
}

// 微信登录接口
router.post('/wechat', async (req, res) => {
  try {
    const { platform, timestamp } = req.body;
    
    // 模拟微信登录流程
    // 在实际应用中，这里需要:
    // 1. 调用微信SDK获取授权码
    // 2. 使用授权码向微信服务器换取access_token
    // 3. 使用access_token获取用户信息
    
    // 模拟微信用户信息
    const wechatUser = {
      openid: 'wx_' + crypto.randomBytes(16).toString('hex'),
      nickname: '微信用户' + Math.floor(Math.random() * 1000),
      avatar: 'https://via.placeholder.com/100x100?text=WX',
      unionid: 'union_' + crypto.randomBytes(16).toString('hex')
    };
    
    // 检查用户是否已存在
    let user = Array.from(users.values()).find(u => u.wechatOpenid === wechatUser.openid);
    
    if (!user) {
      // 创建新用户
      const userId = 'user_' + Date.now();
      user = {
        id: userId,
        name: wechatUser.nickname,
        avatar: wechatUser.avatar,
        wechatOpenid: wechatUser.openid,
        wechatUnionid: wechatUser.unionid,
        loginType: 'wechat',
        createdAt: new Date().toISOString(),
        lastLoginAt: new Date().toISOString()
      };
      users.set(userId, user);
    } else {
      // 更新最后登录时间
      user.lastLoginAt = new Date().toISOString();
    }
    
    // 生成JWT token
    const token = generateToken(user);
    
    res.json({
      success: true,
      message: '微信登录成功',
      token: token,
      user: {
        id: user.id,
        name: user.name,
        avatar: user.avatar,
        loginType: user.loginType
      }
    });
    
  } catch (error) {
    console.error('微信登录错误:', error);
    res.status(500).json({
      success: false,
      message: '微信登录失败，请稍后重试'
    });
  }
});

// 支付宝登录接口
router.post('/alipay', async (req, res) => {
  try {
    const { platform, timestamp } = req.body;
    
    // 模拟支付宝登录流程
    // 在实际应用中，这里需要:
    // 1. 调用支付宝SDK获取授权码
    // 2. 使用授权码向支付宝服务器换取access_token
    // 3. 使用access_token获取用户信息
    
    // 模拟支付宝用户信息
    const alipayUser = {
      userId: 'alipay_' + crypto.randomBytes(16).toString('hex'),
      nickName: '支付宝用户' + Math.floor(Math.random() * 1000),
      avatar: 'https://via.placeholder.com/100x100?text=ALI'
    };
    
    // 检查用户是否已存在
    let user = Array.from(users.values()).find(u => u.alipayUserId === alipayUser.userId);
    
    if (!user) {
      // 创建新用户
      const userId = 'user_' + Date.now();
      user = {
        id: userId,
        name: alipayUser.nickName,
        avatar: alipayUser.avatar,
        alipayUserId: alipayUser.userId,
        loginType: 'alipay',
        createdAt: new Date().toISOString(),
        lastLoginAt: new Date().toISOString()
      };
      users.set(userId, user);
    } else {
      // 更新最后登录时间
      user.lastLoginAt = new Date().toISOString();
    }
    
    // 生成JWT token
    const token = generateToken(user);
    
    res.json({
      success: true,
      message: '支付宝登录成功',
      token: token,
      user: {
        id: user.id,
        name: user.name,
        avatar: user.avatar,
        loginType: user.loginType
      }
    });
    
  } catch (error) {
    console.error('支付宝登录错误:', error);
    res.status(500).json({
      success: false,
      message: '支付宝登录失败，请稍后重试'
    });
  }
});

// 手机号登录接口
router.post('/login', async (req, res) => {
  try {
    const { phone, code, platform } = req.body;
    
    // 验证验证码（这里简化处理，实际应用中需要验证真实的短信验证码）
    if (code !== '123456') {
      return res.status(400).json({
        success: false,
        message: '验证码错误'
      });
    }
    
    // 查找用户
    let user = Array.from(users.values()).find(u => u.phone === phone);
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: '用户不存在，请先注册'
      });
    }
    
    // 更新最后登录时间
    user.lastLoginAt = new Date().toISOString();
    
    // 生成JWT token
    const token = generateToken(user);
    
    res.json({
      success: true,
      message: '登录成功',
      token: token,
      user: {
        id: user.id,
        name: user.name,
        phone: user.phone,
        avatar: user.avatar,
        loginType: user.loginType || 'phone'
      }
    });
    
  } catch (error) {
    console.error('登录错误:', error);
    res.status(500).json({
      success: false,
      message: '登录失败，请稍后重试'
    });
  }
});

// 手机号注册接口
router.post('/register', async (req, res) => {
  try {
    const { phone, code, name, platform } = req.body;
    
    // 验证验证码
    if (code !== '123456') {
      return res.status(400).json({
        success: false,
        message: '验证码错误'
      });
    }
    
    // 检查用户是否已存在
    const existingUser = Array.from(users.values()).find(u => u.phone === phone);
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: '该手机号已注册，请直接登录'
      });
    }
    
    // 创建新用户
    const userId = 'user_' + Date.now();
    const user = {
      id: userId,
      name: name || '用户' + Math.floor(Math.random() * 1000),
      phone: phone,
      avatar: 'https://via.placeholder.com/100x100?text=U',
      loginType: 'phone',
      createdAt: new Date().toISOString(),
      lastLoginAt: new Date().toISOString()
    };
    
    users.set(userId, user);
    
    // 生成JWT token
    const token = generateToken(user);
    
    res.json({
      success: true,
      message: '注册成功',
      token: token,
      user: {
        id: user.id,
        name: user.name,
        phone: user.phone,
        avatar: user.avatar,
        loginType: user.loginType
      }
    });
    
  } catch (error) {
    console.error('注册错误:', error);
    res.status(500).json({
      success: false,
      message: '注册失败，请稍后重试'
    });
  }
});

// 发送验证码接口
router.post('/send-code', async (req, res) => {
  try {
    const { phone } = req.body;
    
    // 验证手机号格式
    const phoneRegex = /^1[3-9]\d{9}$/;
    if (!phoneRegex.test(phone)) {
      return res.status(400).json({
        success: false,
        message: '手机号格式不正确'
      });
    }
    
    // 模拟发送短信验证码
    // 在实际应用中，这里需要调用短信服务商的API
    console.log(`发送验证码到 ${phone}: 123456`);
    
    res.json({
      success: true,
      message: '验证码发送成功，请注意查收'
    });
    
  } catch (error) {
    console.error('发送验证码错误:', error);
    res.status(500).json({
      success: false,
      message: '验证码发送失败，请稍后重试'
    });
  }
});

// 验证token中间件
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({
      success: false,
      message: '访问令牌缺失'
    });
  }
  
  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({
        success: false,
        message: '访问令牌无效'
      });
    }
    req.user = user;
    next();
  });
}

// 获取用户信息接口
router.get('/profile', authenticateToken, (req, res) => {
  const user = users.get(req.user.userId);
  if (!user) {
    return res.status(404).json({
      success: false,
      message: '用户不存在'
    });
  }
  
  res.json({
    success: true,
    user: {
      id: user.id,
      name: user.name,
      phone: user.phone,
      avatar: user.avatar,
      loginType: user.loginType,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt
    }
  });
});

module.exports = router;