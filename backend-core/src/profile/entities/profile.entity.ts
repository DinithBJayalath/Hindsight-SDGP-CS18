import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, HydratedDocument } from 'mongoose';

export type ProfileDocument = HydratedDocument<Profile>;

@Schema({ timestamps: true })
export class Profile {
  @Prop({ required: true, unique: true, ref: 'User' })
  email: string;  // Foreign key referencing User.email

  @Prop({ required: true })
  name: string;

  @Prop()
  picture?: string;

  @Prop({ default: false })
  isVerified: boolean;

  @Prop()
  dateOfBirth?: Date;

  @Prop()
  country?: string;

  @Prop()
  city?: string;

  @Prop({ default: '' })
  bio: string;

  @Prop({ default: false })
  biometricAuthentication: boolean;

  @Prop({ default: false })
  cloudBackup: boolean;

  @Prop({ default: true })
  pushNotifications: boolean;

  @Prop({ default: 'en' })
  language: string;
}

export const ProfileSchema = SchemaFactory.createForClass(Profile);
