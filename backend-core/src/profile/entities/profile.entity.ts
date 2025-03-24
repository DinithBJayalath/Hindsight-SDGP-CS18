import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { User } from '../../user/entities/user.entity';

export type ProfileDocument = Document & Profile;

@Schema({ timestamps: true })
export class Profile {
  _id: Types.ObjectId;

  @Prop({ 
    type: Types.ObjectId, 
    ref: 'User', 
    required: true, 
    unique: true,
    index: true 
  })
  user: Types.ObjectId;

  @Prop({ required: true, unique: true, index: true })
  email: string;

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
