import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as fs from 'fs';

const httpsOptions = {
  key: fs.readFileSync("../resources/server.key"),
  cert: fs.readFileSync("../resources/server.crt"),
};

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    httpsOptions,
  });
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
