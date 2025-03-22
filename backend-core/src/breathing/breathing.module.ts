import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { BreathingController } from "./breathing.controller";
import { BreathingService } from "./breathing.service";
import {
  BreathingSession,
  BreathingSessionSchema,
} from "./schemas/breathing-session.schema";

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: BreathingSession.name, schema: BreathingSessionSchema },
    ]),
  ],
  controllers: [BreathingController],
  providers: [BreathingService],
})
export class BreathingModule {}
