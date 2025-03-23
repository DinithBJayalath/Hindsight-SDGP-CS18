import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Schema as MongooseSchema } from 'mongoose';

export type MoodDocument = Mood & Document;

@Schema({ timestamps: true })
export class EntrySchema {
  @Prop({ required: true })
  mood: string;

  @Prop({ type: Date, default: Date.now })
  createdAt: Date;
}

@Schema()
export class Mood {
  @Prop({ required: true })
  userId: string;
  
  @Prop({ type: MongooseSchema.Types.ObjectId, ref: 'Profile' })
  profileId: MongooseSchema.Types.ObjectId;

  @Prop({ required: true })
  mood: string;

  @Prop({ type: Date, required: true })
  date: Date;

  @Prop()
  note: string;

  @Prop({ type: [EntrySchema], default: [] })
  entries: EntrySchema[];
}

export const MoodSchema = SchemaFactory.createForClass(Mood);