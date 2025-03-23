import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { Document, Schema as MongooseSchema } from "mongoose";

export type DrawingDocument = Drawing & Document;

@Schema({ timestamps: true })
export class Drawing {
  @Prop({ required: true })
  title: string;

  @Prop({ required: true })
  imageData: string; // Base64 encoded image data

  @Prop({ required: true })
  userId: string; // To identify which user created this drawing

  @Prop({ default: Date.now })
  createdAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const DrawingSchema = SchemaFactory.createForClass(Drawing);
