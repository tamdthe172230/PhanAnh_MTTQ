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
    <title>Đăng nhập Quản lý | Ủy ban MTTQ Phường Liên Hòa</title>
    <link rel="icon" href="<%= ctx %>/assets/logo.png" type="image/png">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --red: #b5000b;
            --red-dark: #8b0000;
            --text: #212529;
            --muted: #6c757d;
            --border: #e9ecef;
            --bg: #f5f6f8;
            --white: #ffffff;
            --radius: 6px;
        }

        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background: var(--bg);
            color: var(--text);
            font-size: 14px;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ── HEADER BANNER ── */
        .site-banner {
            background: linear-gradient(135deg, #b5000b 0%, #96001f 40%, #c0392b 100%);
            padding: 24px 0;
            box-shadow: inset 0 -4px 10px rgba(0, 0, 0, .15);
        }

        .banner-inner {
            max-width: 1360px;
            margin: 0 auto;
            padding: 0 24px;
            width: 100%;
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .banner-logo {
            width: 96px;
            height: 96px;
            flex-shrink: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, .15);
            border: 3px solid rgba(255, 255, 255, .4);
            box-shadow: 0 4px 12px rgba(0, 0, 0, .2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            overflow: hidden;
        }

        .banner-logo img {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            object-fit: cover;
        }

        .banner-text {
            color: #fff;
        }

        .banner-text h1 {
            font-size: 1.75rem;
            font-weight: 800;
            letter-spacing: .5px;
            text-transform: uppercase;
            line-height: 1.25;
            text-shadow: 0 2px 4px rgba(0, 0, 0, .2);
        }

        .banner-text p {
            font-size: .95rem;
            font-weight: 700;
            color: #ffd54f;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            margin-top: 6px;
            text-shadow: 0 1px 2px rgba(0, 0, 0, .2);
        }

        /* ── NAVBAR ── */
        .site-navbar {
            background: #b5000b;
            border-top: 1px solid rgba(255, 255, 255, .15);
        }

        .navbar-inner {
            max-width: 1360px;
            margin: 0 auto;
            padding: 0 24px;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .nav-links {
            list-style: none;
            display: flex;
        }

        .nav-links li a {
            display: block;
            padding: 15px 22px;
            color: rgba(255, 255, 255, .92);
            font-weight: 700;
            font-size: .98rem;
            text-decoration: none;
            transition: background .15s;
        }

        .nav-links li a:hover {
            background: rgba(255, 255, 255, .15);
            color: #fff;
        }

        .nav-links li a.active {
            background: rgba(255, 255, 255, .25);
            color: #fff;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-login {
            padding: 8px 20px;
            border: 1.5px solid rgba(255, 255, 255, .8);
            color: #fff;
            background: transparent;
            border-radius: 6px;
            font-size: .9rem;
            font-weight: 700;
            text-decoration: none;
            transition: all .15s;
        }

        .btn-login:hover {
            background: rgba(255, 255, 255, .2);
            color: #fff;
        }

        /* ── MAIN CONTENT ── */
        .page-wrap {
            max-width: 1360px;
            margin: 35px auto 70px;
            padding: 0 24px;
            flex: 1;
            width: 100%;
        }

        .login-card {
            max-width: 440px;
            margin: 40px auto;
            background: var(--white);
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, .08);
            overflow: hidden;
            border: 1px solid #e5e7eb;
        }

        .login-card-header {
            background: var(--red);
            color: #fff;
            padding: 16px 24px;
            font-size: 1.1rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .login-card-body {
            padding: 32px 28px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            font-size: .9rem;
            margin-bottom: 8px;
            color: var(--text);
        }

        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #ced4da;
            border-radius: var(--radius);
            font-size: .95rem;
            color: var(--text);
            background: var(--white);
            transition: border-color .15s;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--red);
            box-shadow: 0 0 0 3px rgba(181, 0, 11, 0.12);
        }

        .btn-submit {
            width: 100%;
            padding: 12px;
            background: var(--red);
            color: #fff;
            border: none;
            border-radius: var(--radius);
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: background .15s;
            margin-top: 8px;
        }

        .btn-submit:hover {
            background: var(--red-dark);
        }

        .btn-submit:disabled {
            opacity: .6;
            cursor: not-allowed;
        }

        .alert-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #dc2626;
            padding: 12px 16px;
            border-radius: var(--radius);
            font-size: .88rem;
            margin-bottom: 20px;
            display: none;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: .88rem;
            color: var(--muted);
            text-decoration: none;
            font-weight: 600;
        }

        .back-link:hover {
            color: var(--red);
            text-decoration: underline;
        }

        /* ── FOOTER ── */
        .site-footer {
            background: #2b2b2b;
            color: #ccc;
            padding: 24px 0 16px;
            margin-top: auto;
            font-size: .85rem;
        }

        .footer-inner {
            max-width: 1360px;
            margin: 0 auto;
            padding: 0 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

        .footer-left div, .footer-right div {
            margin-bottom: 4px;
        }

        .footer-right {
            text-align: right;
        }

        .footer-copy {
            max-width: 1360px;
            margin: 16px auto 0;
            text-align: center;
            font-size: .78rem;
            color: #888;
            border-top: 1px solid #444;
            padding-top: 12px;
        }

        @media(max-width: 640px) {
            .banner-text h1 { font-size: 1.1rem; }
            .banner-logo { width: 64px; height: 64px; }
            .banner-logo img { width: 60px; height: 60px; }
            .footer-inner { flex-direction: column; text-align: center; }
            .footer-right { text-align: center; }
        }
    </style>
</head>

<body>
    <!-- ── HEADER BANNER ── -->
    <header>
        <div class="site-banner">
            <div class="banner-inner">
                <div class="banner-logo">
                    <img src="<%= ctx %>/assets/logo.png" alt="Logo MTTQ" onerror="this.parentElement.textContent='🏛️'">
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
                <div class="navbar-right">
                    <a href="<%= ctx %>/phan-anh-login" class="btn-login">Đăng nhập</a>
                </div>
            </div>
        </nav>
    </header>

    <!-- ── MAIN CONTENT ── -->
    <div class="page-wrap">
        <div class="login-card">
            <div class="login-card-header">
                <span>🔐</span>
                <span>Xác thực Quản trị viên</span>
            </div>
            <div class="login-card-body">
                <div class="alert-error" id="alertError"></div>
                <div class="form-group">
                    <label class="form-label" for="username">Tên đăng nhập</label>
                    <input type="text" id="username" class="form-control" placeholder="Nhập tên đăng nhập admin..." autocomplete="username">
                </div>
                <div class="form-group">
                    <label class="form-label" for="password">Mật khẩu</label>
                    <input type="password" id="password" class="form-control" placeholder="Nhập mật khẩu..." autocomplete="current-password" onkeydown="if(event.key==='Enter') doLogin()">
                </div>
                <button class="btn-submit" id="btnLogin" onclick="doLogin()">🔐 Đăng nhập hệ thống</button>
                <a href="<%= ctx %>/phan-anh" class="back-link">← Quay lại trang phản ánh</a>
            </div>
        </div>
    </div>

    <!-- ── FOOTER ── -->
    <footer class="site-footer">
        <div class="footer-inner">
            <div class="footer-left">
                <div>Trung tâm CNTT & Truyền thông Tỉnh Quảng Ninh</div>
                <div>Ủy ban MTTQ Việt Nam Phường Liên Hòa, Tỉnh Quảng Ninh</div>
            </div>
            <div class="footer-right">
                <div>Hỗ trợ kỹ thuật: CNTT Phường Liên Hòa</div>
                <div>ĐT: 0123.456.789</div>
            </div>
        </div>
        <div class="footer-copy">Bản quyền thuộc về Ủy ban MTTQ Việt Nam Phường Liên Hòa © 2025</div>
    </footer>

    <script>
    (function () {
        'use strict';
        var BASE = '<%= ctx %>';
        var btn = document.getElementById('btnLogin');
        var err = document.getElementById('alertError');
        window.doLogin = function () {
            var username = document.getElementById('username').value.trim();
            var password = document.getElementById('password').value;
            if (!username || !password) {
                showError('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!');
                return;
            }
            btn.disabled = true;
            btn.textContent = '⏳ Đang xác thực...';
            err.style.display = 'none';
            var params = new URLSearchParams();
            params.append('username', username);
            params.append('password', password);
            fetch(BASE + '/api/auth', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params
            })
            .then(function (r) { return r.json(); })
            .then(function (res) {
                if (res.success) {
                    window.location.href = BASE + '/phan-anh#quan-ly';
                } else {
                    showError(res.message || 'Sai tài khoản hoặc mật khẩu!');
                }
            })
            .catch(function () {
                showError('Lỗi kết nối máy chủ. Vui lòng thử lại!');
            })
            .finally(function () {
                btn.disabled = false;
                btn.textContent = '🔐 Đăng nhập hệ thống';
            });
        };
        function showError(msg) {
            err.textContent = msg;
            err.style.display = 'block';
        }
        document.getElementById('username').focus();
    })();
    </script>
</body>
</html>
