import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { Document, Schema as MongooseSchema } from "mongoose";

export type BreathingSessionDocument = BreathingSession & Document;

@Schema({ timestamps: true })
export class BreathingSession {
  @Prop({ required: true })
  userId: string;

  @Prop({ required: true })
  duration: number; // Duration in seconds

  @Prop()
  audioRecording: string; // Base64 encoded audio data (optional)

  @Prop({ default: Date.now })
  createdAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const BreathingSessionSchema =
  SchemaFactory.createForClass(BreathingSession);
