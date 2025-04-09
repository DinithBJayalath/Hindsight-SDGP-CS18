import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type ProfileDocument = Document & Profile;

@Schema({ timestamps: true })
export class Profile {
  _id: Types.ObjectId;

  @Prop({ required: true, unique: true, index: true })
  auth0Id: string;

  @Prop({ required: true, unique: true, index: true })
  email: string;

  @Prop({ required: true })
  name: string;

  @Prop()
  picture?: string;

  @Prop()
  country?: string;

  @Prop()
  city?: string;

  @Prop({ default: '' })
  bio: string;

  // Settings
  @Prop({ default: false })
  biometricAuthentication: boolean;

  @Prop({ default: false })
  cloudBackup: boolean;

  @Prop({ default: true })
  pushNotifications: boolean;

  @Prop({ default: 'en' })
  language: string;

  @Prop({ default: Date.now })
  createdAt: Date;

  @Prop({ default: Date.now })
  updatedAt: Date;
}

export const ProfileSchema = SchemaFactory.createForClass(Profile);

// Add a pre-save hook to set a unique ObjectId for the user field if it's not set
// ProfileSchema.pre('save', function(next) {
//   if (this.isNew && !this.user) {
//     this.user = new Types.ObjectId();
//   }
//   next();
// }); 