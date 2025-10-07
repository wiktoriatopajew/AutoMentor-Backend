# AutoMentor Backend

Backend API aplikacji AutoMentor zbudowany w Node.js + Express + TypeScript.

## 🚀 Deploy na Railway

1. **Utwórz nowy projekt na Railway**
   - Wejdź na https://railway.app
   - Kliknij "New Project" → "Deploy from GitHub"
   - Wybierz to repozytorium (`AutoMentor-Backend`)

2. **Ustaw zmienne środowiskowe** (wymagane)
   - W panelu Railway → Variables → dodaj:
   ```
   SESSION_SECRET=twoje-losowe-haslo-123
   ```

3. **Podłącz bazę danych** (opcjonalne)
   - Jeśli masz bazę PostgreSQL na Railway:
   ```
   DATABASE_URL=${{ Postgres.DATABASE_URL }}
   ```

4. **Railway automatycznie:**
   - Wykryje `railway.toml`
   - Uruchomi `npm install && npm run build`
   - Wystartuje serwer przez `npm start`

5. **Włącz publiczny dostęp:**
   - W ustawieniach serwisu kliknij "Generate Domain"
   - Otrzymasz URL typu: `https://your-backend.up.railway.app`

## API Endpoints

- `GET /api/health` - Health check
- `POST /api/auth/*` - Autoryzacja
- `GET /api/users/*` - Zarządzanie użytkownikami
- WebSocket support dla czatu

## Lokalne uruchomienie

```bash
npm install
npm run build
npm start
```

Serwer będzie dostępny pod http://localhost:5000