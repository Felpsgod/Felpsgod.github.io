// sw-notificacoes.js - Service Worker para notificações avançadas
const CACHE_NAME = 'fincontrol-notifications-v2';

// Instalação
self.addEventListener('install', (event) => {
    self.skipWaiting();
    console.log('🔔 Service Worker de notificações instalado');
});

// Ativação
self.addEventListener('activate', (event) => {
    event.waitUntil(self.clients.claim());
    console.log('🔔 Service Worker de notificações ativado');
});

// Mensagens da aplicação principal
self.addEventListener('message', (event) =>{
        event.waitUntil(verificarVencimentosENotificar());
});

// Notificações push (para quando implementar Push API)
self.addEventListener('push', (event) => {
    if (event.data) {
        const data = event.data.json();
        
        const options = {
            body: data.body,
            icon: '/icon-192.png',
            badge: '/icon-192.png',
            vibrate: data.vibrate || [100, 50, 100],
            tag: data.tag,
            requireInteraction: data.urgente || false,
            data: {
                url: self.location.origin,
                emprestimoId: data.emprestimoId
            },
            actions: data.urgente ? [
                {
                    action: 'open',
                    title: '📱 Abrir App'
                }
            ] : []
        };

        event.waitUntil(
            self.registration.showNotification(data.title, options)
        );
    }
});

// Clique na notificação
self.addEventListener('notificationclick', (event) => {
    event.notification.close();
    
    event.waitUntil(
        clients.matchAll({ 
            type: 'window',
            includeUncontrolled: true 
        }).then((clientList) => {
            // Tentar focar em uma janela existente
            for (const client of clientList) {
                if (client.url.includes(self.location.origin) && 'focus' in client) {
                    return client.focus();
                }
            }
            
            // Se não encontrou, abrir nova janela
            if (clients.openWindow) {
                return clients.openWindow(self.location.origin);
            }
        })
    );
});

// Background Sync (para verificações em background)
self.addEventListener('sync', (event) => {
        event.waitUntil(verificarVencimentosENotificar());
});

// Função para verificar vencimentos (em background)
async function verificarVencimentosENotificar() {
    try {
        // Aqui você pode implementar uma verificação em background
        // que funciona mesmo quando o app não está aberto
        console.log('🔔 Verificação de vencimentos em background');
        
        // Enviar mensagem para a aplicação principal
        const clients = await self.clients.matchAll();
        clients.forEach(client => {
            client.postMessage({
                type: 'BACKGROUND_VERIFICATION',
                timestamp: new Date().toISOString()
            });
        });
        
    } catch (error) {
        console.error('Erro na verificação em background:', error);
    }
}

// Periodic Background Sync (funciona offline também)
async function registerPeriodicSync() {
    if ('periodicSync' in self.registration) {
        try {
            await self.registration.periodicSync.register('verificacao-vencimentos', {
                minInterval: 12 * 60 * 60 * 1000 // 12 horas
            });
            console.log('🔔 Periodic Background Sync registrado');
        } catch (error) {
            console.log('🔔 Periodic Background Sync não suportado:', error);
        }
    }
}

// Inicializar quando o Service Worker é ativado
self.addEventListener('activate', (event) => {
    event.waitUntil(registerPeriodicSync());
});
