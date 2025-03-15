// src/user/user.module.ts
import { Module, forwardRef } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { UserService } from './user.service';
import { User, UserSchema } from './entities/user.entity';
import { ProfileModule } from '../profile/profile.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: User.name, schema: UserSchema }]),
    forwardRef(() => ProfileModule),
  ],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}

