import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { DrawingsController } from "./drawings.controller";
import { DrawingsService } from "./drawings.service";
import { Drawing, DrawingSchema } from "./schemas/drawing.schema";

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Drawing.name, schema: DrawingSchema }]),
  ],
  controllers: [DrawingsController],
  providers: [DrawingsService],
})
export class DrawingsModule {}
