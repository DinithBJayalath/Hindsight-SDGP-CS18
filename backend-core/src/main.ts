// src/main.ts
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';
import * as fs from 'fs';

// const httpsOptions = {
//   key: fs.readFileSync("../resources/server.key"),
//   cert: fs.readFileSync("../resources/server.crt"),
// };

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors({
    origin: '*', // During development, you can use '*' to accept requests from anywhere
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    preflightContinue: false,
    optionsSuccessStatus: 204,
    credentials: true,
    allowedHeaders: 'Origin,X-Requested-With,Content-Type,Accept,Authorization',
  });
  
  // Global validation pipe
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    transform: true,
    forbidNonWhitelisted: true,
  }));
  
  await activitiesSeedService.seed();
  const activitiesSeedService = app.get(ActivitiesSeedService);
  
  await app.listen(process.env.PORT ?? 3000, '0.0.0.0');
}
bootstrap();