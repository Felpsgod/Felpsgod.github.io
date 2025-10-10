<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ECO - Sistema de Orçamentos</title>
    <!-- Firebase SDK -->
    <script src="https://www.gstatic.com/firebasejs/9.22.1/firebase-app-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/9.22.1/firebase-auth-compat.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Estilos da Página de Login */
        .login-page {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #00855B 0%, #20343D 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        .login-logo {
            margin-bottom: 30px;
        }

        .login-logo img {
            width: 120px;
            height: 120px;
            object-fit: contain;
        }

        .login-title {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 24px;
        }

        .login-subtitle {
            color: #7f8c8d;
            margin-bottom: 30px;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #2c3e50;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ecf0f1;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            width: 100%;
        }

        .btn-primary {
            background: #85BFCD;
            color: white;
        }

        .btn-primary:hover {
            background: #2980b9;
        }

        .btn-primary:disabled {
            background: #bdc3c7;
            cursor: not-allowed;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin: 15px 0;
            font-size: 14px;
            font-weight: 500;
            display: none;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            display: block;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            display: block;
        }

        .loading {
            display: none;
            text-align: center;
            margin: 10px 0;
        }

        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #3498db;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .user-info {
            margin-top: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            text-align: left;
        }

        .user-info h3 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .logout-btn {
            background: #e74c3c;
            color: white;
            margin-top: 10px;
        }

        .logout-btn:hover {
            background: #c0392b;
        }

        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <!-- Página de Login -->
    <div id="loginPage" class="login-page">
        <div class="login-container">
            <div class="login-logo">
                <img src="https://imgur.com/kpCeqqJ.png" alt="ECO - Centro de Infusões">
            </div>
            
            <h1 class="login-title">ECO - CENTRO DE INFUSÕES</h1>
            <p class="login-subtitle">Sistema de Geração de Orçamentos Médicos</p>

            <!-- Formulário de Login -->
            <div id="loginForm">
                <div class="form-group">
                    <label for="email">E-mail</label>
                    <input type="email" id="email" placeholder="seu@email.com" required>
                </div>

                <div class="form-group">
                    <label for="password">Senha</label>
                    <input type="password" id="password" placeholder="Sua senha" required>
                </div>

                <div id="loginAlert" class="alert"></div>

                <div class="loading" id="loginLoading">
                    <div class="loading-spinner"></div>
                    <p>Entrando...</p>
                </div>

                <button class="btn btn-primary" onclick="login()" id="loginBtn">Entrar no Sistema</button>

                <div style="margin-top: 20px; font-size: 12px; color: #7f8c8d;">
                    <p>Para acessar o sistema, utilize as credenciais fornecidas pela administração.</p>
                </div>
            </div>

            <!-- Informações do Usuário (após login) -->
            <div id="userInfo" class="user-info hidden">
                <h3>Usuário Logado</h3>
                <p id="userEmail"></p>
                <button class="btn logout-btn" onclick="logout()">Sair do Sistema</button>
            </div>
        </div>
    </div>

    <script>
        // =============================================
        // CONFIGURAÇÃO FIREBASE E AUTENTICAÇÃO
        // =============================================

        // Configuração do Firebase
   const firebaseConfig = {
            apiKey: "AIzaSyCkZQweHWGsfEu8OjHBACCxv_dbYcFAyv4",
            authDomain: "gerar-orcamento-bd4d1.firebaseapp.com",
            databaseURL: "https://gerar-orcamento-bd4d1-default-rtdb.firebaseio.com",
            projectId: "gerar-orcamento-bd4d1",
            storageBucket: "gerar-orcamento-bd4d1.firebasestorage.app",
            messagingSenderId: "779065759341",
            appId: "1:779065759341:web:451d068c476580c542d164",
            measurementId: "G-QWKFHK5EFW"
        };
        // Inicializar Firebase
        firebase.initializeApp(firebaseConfig);
        const auth = firebase.auth();

        // Verificar estado de autenticação
        auth.onAuthStateChanged((user) => {
            if (user) {
                // Usuário está logado
                showMainSystem(user);
            } else {
                // Usuário não está logado
                showLoginForm();
            }
        });

        // Função de login
        async function login() {
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const loginAlert = document.getElementById('loginAlert');
            const loginLoading = document.getElementById('loginLoading');
            const loginBtn = document.getElementById('loginBtn');

            // Validação básica
            if (!email || !password) {
                showAlert('Por favor, preencha todos os campos.', 'error', loginAlert);
                return;
            }

            // Mostrar loading
            loginLoading.style.display = 'block';
            loginBtn.disabled = true;

            try {
                // Fazer login com Firebase Auth
                const userCredential = await auth.signInWithEmailAndPassword(email, password);
                const user = userCredential.user;
                
                showAlert('Login realizado com sucesso!', 'success', loginAlert);
                
                // Pequeno delay para mostrar a mensagem de sucesso
                setTimeout(() => {
                    showMainSystem(user);
                }, 1000);

            } catch (error) {
                // Tratar erros de autenticação
                let errorMessage = 'Erro ao fazer login. ';
                
                switch (error.code) {
                    case 'auth/invalid-email':
                        errorMessage += 'E-mail inválido.';
                        break;
                    case 'auth/user-disabled':
                        errorMessage += 'Esta conta foi desativada.';
                        break;
                    case 'auth/user-not-found':
                        errorMessage += 'Usuário não encontrado.';
                        break;
                    case 'auth/wrong-password':
                        errorMessage += 'Senha incorreta.';
                        break;
                    case 'auth/too-many-requests':
                        errorMessage += 'Muitas tentativas de login. Tente novamente mais tarde.';
                        break;
                    default:
                        errorMessage += error.message;
                }
                
                showAlert(errorMessage, 'error', loginAlert);
            } finally {
                // Esconder loading
                loginLoading.style.display = 'none';
                loginBtn.disabled = false;
            }
        }

        // Função de logout
        function logout() {
            auth.signOut().then(() => {
                showAlert('Logout realizado com sucesso!', 'success', document.getElementById('loginAlert'));
                showLoginForm();
            }).catch((error) => {
                showAlert('Erro ao fazer logout: ' + error.message, 'error', document.getElementById('loginAlert'));
            });
        }

        // Mostrar formulário de login
        function showLoginForm() {
            document.getElementById('loginPage').classList.remove('hidden');
            
            // Limpar campos
            document.getElementById('email').value = '';
            document.getElementById('password').value = '';
        }

        // Mostrar sistema principal (redirecionar para outro HTML)
        function showMainSystem(user) {
            // Redirecionar para a página principal do sistema
            localStorage.setItem('userEmail', user.email);

            window.location.href = 'https://felpsgod.github.io/';
            //  localStorage.getItem('userEmail');


        }

        // Função para mostrar alertas
        function showAlert(message, type, container) {
            container.textContent = message;
            container.className = `alert alert-${type}`;
            container.style.display = 'block';
            
            // Auto-esconder alertas de sucesso
            if (type === 'success') {
                setTimeout(() => {
                    container.style.display = 'none';
                }, 3000);
            }
        }

        // Permitir login com Enter
        document.getElementById('password').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                login();
            }
        });
    </script>
</body>
</html>
