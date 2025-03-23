import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { ActivitiesService } from "./activities.service";
import { ActivitiesController } from "./activities.controller";
import { Activity, ActivitySchema } from "./schemas/activity.schema";
import { ActivitiesSeedService } from "./seed/activities.seed";

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Activity.name, schema: ActivitySchema },
    ]),
  ],
  controllers: [ActivitiesController],
  providers: [ActivitiesService, ActivitiesSeedService],
})
export class ActivitiesModule {}
