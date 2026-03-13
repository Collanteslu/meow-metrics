FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

EXPOSE 3001

# Create entrypoint script for database setup
RUN echo '#!/bin/sh\nset -e\necho "🗄️  Running database migrations..."\nnpm run db:migrate\necho "🌱 Seeding database..."\nnpm run db:seed\necho "✅ Database ready!"\necho "🚀 Starting application..."\nexec npm run start:prod' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
