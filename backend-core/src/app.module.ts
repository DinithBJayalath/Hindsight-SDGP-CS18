import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { ActivitiesModule } from "./activities/activities/activities.module";

@Module({
  imports: [
    // Temporarily comment out MongoDB connection for testing
    // MongooseModule.forRoot("mongodb://localhost:27017/activities_db"),
    ActivitiesModule,
  ],
})
export class AppModule {}
