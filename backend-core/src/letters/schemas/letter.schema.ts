import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { Document, Schema as MongooseSchema } from "mongoose";

export type LetterDocument = Letter & Document;

@Schema({ timestamps: true })
export class Letter {
  @Prop({ required: true })
  title: string;

  @Prop({ required: true })
  content: string;

  @Prop({ required: true })
  userId: string; // To identify which user created this letter

  @Prop()
  deliveryDate: Date; // Optional future date for "letter to future self"

  @Prop({ default: false })
  isDelivered: boolean;

  @Prop({ default: Date.now })
  createdAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const LetterSchema = SchemaFactory.createForClass(Letter);
