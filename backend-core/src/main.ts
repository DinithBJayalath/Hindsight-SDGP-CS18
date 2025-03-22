import { NestFactory } from "@nestjs/core";
import { AppModule } from "src/app.module";
import { ValidationPipe } from "@nestjs/common";
import { ActivitiesSeedService } from "./activities/activities/seed/activities.seed";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable CORS with specific options
  app.enableCors({
    origin: true, // Allow all origins in development
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
    credentials: true,
  });

  // Enable validation pipes
  app.useGlobalPipes(new ValidationPipe());

  // Seed activities
  const activitiesSeedService = app.get(ActivitiesSeedService);
  await activitiesSeedService.seed();

  await app.listen(3000);
}
bootstrap();
