// src/user/user.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}
  async findById(id: string): Promise<User | null> {
    return this.userRepository.findOne({ where: { auth0Id: id } });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.userRepository.findOne({ where: { email } });
  }

  async findOrCreateUser(userProfile: any): Promise<User> {
    let user = await this.findById(userProfile.sub);

    if (!user) {
      user = this.userRepository.create({
        auth0Id: userProfile.sub,
        email: userProfile.email,
        name: userProfile.name || '',
        picture: userProfile.picture || '',
      });
      await this.userRepository.save(user);
    } else {
      // Update user information if needed
      user.email = userProfile.email;
      user.name = userProfile.name || user.name;
      user.picture = userProfile.picture || user.picture;
      await this.userRepository.save(user);
    }

    return user;
  }
}

