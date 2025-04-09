import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { Profile } from './profile.entity';

// Define the structure for each mood entry
@Schema({ _id: false })
export class MoodEntry {
  @Prop({ required: true })
  mood: string;

  @Prop({ required: true })
  emotion: string;

  @Prop({ type: [String], default: [] })
  factors: string[];

  @Prop({ default: false })
  isJournal: boolean;

  @Prop({ type: String, default: null })
  journalTitle: string;

  @Prop({ type: String, default: null })
  journalContent: string;

  @Prop({ type: Number, default: 0 })
  sentiment: number;

  @Prop({ default: Date.now })
  createdAt: Date;
}

export type MoodDocument = Document & Mood;

@Schema({ timestamps: true })
export class Mood {
  _id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Profile', required: true, index: true, unique: true })
  profileId: Types.ObjectId;

  @Prop({ type: [MoodEntry], default: [] })
  entries: MoodEntry[];

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const MoodSchema = SchemaFactory.createForClass(Mood);
