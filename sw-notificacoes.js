// sw-notificacoes.js - Service Worker para notificações em background
const CACHE_NAME = 'fincontrol-notifications-v1';

self.addEventListener('install', (event) => {
    self.skipWaiting();
    console.log('Service Worker de notificações instalado');
});

self.addEventListener('activate', (event) => {
    event.waitUntil(self.clients.claim());
    console.log('Service Worker de notificações ativado');
});

// Receber mensagens da aplicação
self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'VERIFICAR_VENCIMENTOS') {
        verificarVencimentosPeriodicamente();
    }
});

// Notificação quando app está em background
self.addEventListener('push', (event) => {
    if (event.data) {
        const data = event.data.json();
        const options = {
            body: data.body,
            icon: '/icon-192.png',
            badge: '/icon-192.png',
            vibrate: [100, 50, 100],
            data: {
                url: self.location.origin
            }
        };

        event.waitUntil(
            self.registration.showNotification(data.title, options)
        );
    }
});

// Ao clicar na notificação
self.addEventListener('notificationclick', (event) => {
    event.notification.close();
    
    event.waitUntil(
        clients.matchAll({ type: 'window' }).then((clientList) => {
            for (const client of clientList) {
                if (client.url === self.location.origin && 'focus' in client) {
                    return client.focus();
                }
            }
            if (clients.openWindow) {
                return clients.openWindow(self.location.origin);
            }
        })
    );
});
