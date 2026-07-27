<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
    jakarta.servlet.http.HttpSession sess = request.getSession(false);
    if (sess != null && "admin".equals(sess.getAttribute("role"))) {
        response.sendRedirect(ctx + "/phan-anh#quan-ly");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập Quản lý | MTTQ Phường Liên Hòa</title>
    <link rel="icon" href="<%= ctx %>/assets/logo_mttq.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --red:#BB032A; --red-dark:#96001f; --text:#212529; --muted:#6c757d; --border:#dee2e6; --bg:#f8f9fa; --white:#ffffff; --radius:4px; }
        body { font-family:'Inter','Segoe UI',sans-serif; background:var(--bg); color:var(--text); font-size:14px; min-height:100vh; }
        .site-banner { background:linear-gradient(135deg,#c0002a 0%,#a00020 40%,#d45a00 100%); padding:16px 0; }
        .banner-inner { max-width:1320px; margin:0 auto; padding:0 20px; display:flex; align-items:center; gap:20px; }
        .banner-logo { width:72px; height:72px; flex-shrink:0; border-radius:50%; background:rgba(255,255,255,.1); border:2px solid rgba(255,255,255,.3); display:flex; align-items:center; justify-content:center; overflow:hidden; }
        .banner-logo img { width:100%; height:100%; object-fit:cover; border-radius:50%; }
        .banner-text h1 { color:#fff; font-size:1.15rem; font-weight:800; text-transform:uppercase; line-height:1.3; }
        .banner-text p  { color:rgba(255,255,0,.9); font-size:.82rem; font-weight:500; margin-top:3px; }
        .site-navbar { background:var(--red); border-bottom:2px solid var(--red-dark); }
        .navbar-inner { max-width:1320px; margin:0 auto; padding:0 20px; height:42px; display:flex; align-items:center; justify-content:space-between; }
        .nav-links { list-style:none; display:flex; height:100%; }
        .nav-links a { display:flex; align-items:center; padding:0 18px; color:rgba(255,255,255,.75); font-size:.88rem; font-weight:600; text-decoration:none; height:100%; transition:background .15s; }
        .nav-links a:hover { background:rgba(0,0,0,.15); color:#fff; }
        .nav-links a.active { background:rgba(0,0,0,.2); color:#fff; border-bottom:3px solid #fff; }
        .btn-home { background:rgba(255,255,255,.15); border:1px solid rgba(255,255,255,.4); color:#fff; padding:5px 14px; border-radius:var(--radius); font-size:.82rem; font-weight:700; cursor:pointer; text-decoration:none; }
        .login-wrap { max-width:420px; margin:60px auto; padding:0 16px; }
        .login-title { text-align:center; font-size:1.1rem; font-weight:800; color:var(--text); text-transform:uppercase; letter-spacing:.5px; margin-bottom:24px; }
        .login-card { background:var(--white); border-radius:8px; border:1px solid var(--border); box-shadow:0 4px 24px rgba(0,0,0,.08); overflow:hidden; }
        .login-card-header { background:var(--red); color:#fff; padding:14px 20px; font-weight:700; font-size:.95rem; display:flex; align-items:center; gap:10px; }
        .login-card-body { padding:28px 24px; }
        .form-group { margin-bottom:18px; }
        .form-label { display:block; font-size:.85rem; font-weight:600; color:var(--text); margin-bottom:6px; }
        .form-control { width:100%; padding:8px 12px; border:1px solid var(--border); border-radius:var(--radius); font-size:.9rem; color:var(--text); background:var(--white); transition:border-color .15s; font-family:inherit; }
        .form-control:focus { outline:none; border-color:var(--red); }
        .btn-submit { width:100%; padding:10px; background:var(--red); color:#fff; border:none; border-radius:var(--radius); font-size:.95rem; font-weight:700; cursor:pointer; transition:background .15s; margin-top:6px; }
        .btn-submit:hover { background:var(--red-dark); }
        .btn-submit:disabled { opacity:.6; cursor:not-allowed; }
        .alert-error { background:#fef2f2; border:1px solid #fecaca; color:#dc2626; padding:10px 14px; border-radius:var(--radius); font-size:.85rem; margin-bottom:16px; display:none; }
        .back-link { display:block; text-align:center; margin-top:18px; font-size:.83rem; color:var(--muted); text-decoration:none; }
        .back-link:hover { color:var(--red); }
        .site-footer { background:var(--white); border-top:1px solid var(--border); padding:20px; margin-top:60px; text-align:center; font-size:.78rem; color:var(--muted); }
    </style>
</head>
<body>
<header>
    <div class="site-banner">
        <div class="banner-inner">
            <div class="banner-logo">
                <img src="<%= ctx %>/assets/logo_mttq.png" alt="Logo MTTQ" onerror="this.parentElement.textContent='🏛️'">
            </div>
            <div class="banner-text">
                <h1>Ủy ban MTTQ Việt Nam Phường Liên Hòa</h1>
                <p>Cổng tiếp nhận, xử lý phản ánh, kiến nghị của nhân dân</p>
            </div>
        </div>
    </div>
    <nav class="site-navbar">
        <div class="navbar-inner">
            <ul class="nav-links">
                <li><a href="<%= ctx %>/phan-anh">Gửi Phản ánh, Kiến nghị</a></li>
                <li><a href="<%= ctx %>/phan-anh#tracuu">Tra cứu</a></li>
                <li><a href="#" class="active">Quản lý</a></li>
            </ul>
            <a href="<%= ctx %>/" class="btn-home">← Trang chủ</a>
        </div>
    </nav>
</header>
<div class="login-wrap">
    <div class="login-title">Đăng nhập Hệ thống Quản lý</div>
    <div class="login-card">
        <div class="login-card-header"><span>🔐</span><span>Xác thực quản trị viên</span></div>
        <div class="login-card-body">
            <div class="alert-error" id="alertError"></div>
            <div class="form-group">
                <label class="form-label" for="username">Tên đăng nhập</label>
                <input type="text" id="username" class="form-control" placeholder="Nhập tên đăng nhập" autocomplete="username">
            </div>
            <div class="form-group">
                <label class="form-label" for="password">Mật khẩu</label>
                <input type="password" id="password" class="form-control" placeholder="Nhập mật khẩu" autocomplete="current-password" onkeydown="if(event.key==='Enter') doLogin()">
            </div>
            <button class="btn-submit" id="btnLogin" onclick="doLogin()">Đăng nhập</button>
        </div>
    </div>
    <a href="<%= ctx %>/phan-anh" class="back-link">← Quay lại trang phản ánh</a>
</div>
<footer class="site-footer">Bản quyền thuộc về Ủy ban MTTQ Việt Nam Phường Liên Hòa © 2025</footer>
<script>
(function () {
    var BASE = '<%= ctx %>';
    var btn = document.getElementById('btnLogin');
    var err = document.getElementById('alertError');
    window.doLogin = function () {
        var username = document.getElementById('username').value.trim();
        var password = document.getElementById('password').value;
        if (!username || !password) { showError('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!'); return; }
        btn.disabled = true; btn.textContent = 'Đang xác thực...'; err.style.display = 'none';
        var params = new URLSearchParams();
        params.append('username', username); params.append('password', password);
        fetch(BASE + '/api/auth', { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:params })
        .then(function(r) { return r.json(); })
        .then(function(res) {
            if (res.success) { window.location.href = BASE + '/phan-anh#quan-ly'; }
            else { showError(res.message || 'Sai tài khoản hoặc mật khẩu!'); }
        })
        .catch(function() { showError('Lỗi kết nối máy chủ. Vui lòng thử lại!'); })
        .finally(function() { btn.disabled = false; btn.textContent = 'Đăng nhập'; });
    };
    function showError(msg) { err.textContent = msg; err.style.display = 'block'; }
    document.getElementById('username').focus();
})();
</script>
</body>
</html>
