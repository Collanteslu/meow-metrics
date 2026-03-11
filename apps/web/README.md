# Meow Metrics Web Application

Production-grade Next.js 16 web application for managing urban cat colonies.

## 🚀 Quick Start

\`\`\`bash
npm install --legacy-peer-deps
npm run dev
# Web app running at http://localhost:3000
\`\`\`

## 📚 Features

- 🔐 JWT Authentication
- 🏘️ Colony Management
- 🐱 Cat Tracking
- 💊 Health Records
- ✂️ CER Program
- 📊 Reports & Analytics
- 👥 Team Collaboration

## 🛠️ Tech Stack

- **Next.js 16** - React Framework
- **Tailwind CSS v4** - Styling
- **Zustand** - State Management
- **Axios** - HTTP Client
- **TypeScript** - Type Safety

## 📈 Project Structure

\`\`\`
src/
├── app/              # Pages and layouts
│   ├── login/
│   ├── colonies/
│   ├── cats/
│   ├── health/
│   ├── reports/
│   └── collaboration/
├── lib/              # Utilities and services
│   └── api.ts
└── components/       # Reusable components
\`\`\`

## 🚢 Deployment

### Docker
\`\`\`bash
docker build -t meow-metrics-web:latest .
docker run -p 3000:3000 meow-metrics-web:latest
\`\`\`

### Vercel
Connect your GitHub repository to Vercel for automatic deployments.

## 📝 License

MIT
