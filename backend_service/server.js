const http = require('http');
const url = require('url');
const crypto = require('crypto');

const PORT = process.env.PORT || 3000;

// 模拟用户数据库
const users = new Map();

// 生成简单的token
function generateToken(user) {
  const payload = {
    userId: user.id,
    phone: user.phone,
    name: user.name,
    exp: Date.now() + 7 * 24 * 60 * 60 * 1000 // 7天过期
  };
  return Buffer.from(JSON.stringify(payload)).toString('base64');
}

// 解析请求体
function parseBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString();
    });
    req.on('end', () => {
      try {
        resolve(body ? JSON.parse(body) : {});
      } catch (e) {
        reject(e);
      }
    });
  });
}

// 设置CORS头
function setCorsHeaders(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

// 发送JSON响应
function sendJson(res, statusCode, data) {
  setCorsHeaders(res);
  res.writeHead(statusCode, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify(data));
}

// 微信登录处理
function handleWeChatLogin(req, res, body) {
  try {
    // 模拟微信用户信息
    const wechatUser = {
      openid: 'wx_' + crypto.randomBytes(8).toString('hex'),
      nickname: '微信用户' + Math.floor(Math.random() * 1000),
      avatar: 'https://via.placeholder.com/100x100?text=WX'
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
        loginType: 'wechat',
        createdAt: new Date().toISOString(),
        lastLoginAt: new Date().toISOString()
      };
      users.set(userId, user);
    } else {
      user.lastLoginAt = new Date().toISOString();
    }
    
    const token = generateToken(user);
    
    sendJson(res, 200, {
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
    sendJson(res, 500, {
      success: false,
      message: '微信登录失败，请稍后重试'
    });
  }
}

// 支付宝登录处理
function handleAlipayLogin(req, res, body) {
  try {
    // 模拟支付宝用户信息
    const alipayUser = {
      userId: 'alipay_' + crypto.randomBytes(8).toString('hex'),
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
      user.lastLoginAt = new Date().toISOString();
    }
    
    const token = generateToken(user);
    
    sendJson(res, 200, {
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
    sendJson(res, 500, {
      success: false,
      message: '支付宝登录失败，请稍后重试'
    });
  }
}

// 创建HTTP服务器
const server = http.createServer(async (req, res) => {
  const parsedUrl = url.parse(req.url, true);
  const path = parsedUrl.pathname;
  const method = req.method;
  
  console.log(`${new Date().toISOString()} - ${method} ${path}`);
  
  // 处理OPTIONS请求（CORS预检）
  if (method === 'OPTIONS') {
    setCorsHeaders(res);
    res.writeHead(200);
    res.end();
    return;
  }
  
  try {
    // 解析请求体
    const body = method === 'POST' ? await parseBody(req) : {};
    
    // 路由处理
    if (path === '/api/auth/wechat' && method === 'POST') {
      handleWeChatLogin(req, res, body);
    } else if (path === '/api/auth/alipay' && method === 'POST') {
      handleAlipayLogin(req, res, body);
    } else if (path === '/health' && method === 'GET') {
      sendJson(res, 200, {
        status: 'ok',
        timestamp: new Date().toISOString(),
        service: '银帮帮后端服务'
      });
    } else if (path === '/' && method === 'GET') {
      sendJson(res, 200, {
        message: '银帮帮后端API服务',
        version: '1.0.0',
        endpoints: {
          auth: {
            wechat: 'POST /api/auth/wechat',
            alipay: 'POST /api/auth/alipay'
          },
          health: 'GET /health'
        }
      });
    } else {
      sendJson(res, 404, {
        success: false,
        message: '接口不存在'
      });
    }
  } catch (error) {
    console.error('服务器错误:', error);
    sendJson(res, 500, {
      success: false,
      message: '服务器内部错误'
    });
  }
});

// 启动服务器
server.listen(PORT, () => {
  console.log(`\n🚀 银帮帮后端服务已启动`);
  console.log(`📍 服务地址: http://localhost:${PORT}`);
  console.log(`📋 API文档: http://localhost:${PORT}`);
  console.log(`💚 健康检查: http://localhost:${PORT}/health`);
  console.log(`\n📱 支持的登录方式:`);
  console.log(`   • 微信登录: POST /api/auth/wechat`);
  console.log(`   • 支付宝登录: POST /api/auth/alipay`);
  console.log(`\n⏰ 启动时间: ${new Date().toLocaleString()}\n`);
});

module.exports = server;