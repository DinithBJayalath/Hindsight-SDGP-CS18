import { NestFactory } from '@nestjs/core';
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
  await app.listen(process.env.PORT ?? 3000, '0.0.0.0');
}
bootstrap();
