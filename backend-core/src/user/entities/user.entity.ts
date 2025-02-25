
// src/user/entities/user.entity.ts
import {
    Entity,
    Column,
    PrimaryGeneratedColumn,
    CreateDateColumn,
    UpdateDateColumn,
  } from 'typeorm';
  
  @Entity()
  export class User {
    @PrimaryGeneratedColumn('uuid')
    id: string;
  
    @Column({ unique: true })
    auth0Id: string;
  
    @Column({ unique: true })
    email: string;
  
    @Column()
    name: string;
  
    @Column({ nullable: true })
    picture: string;
  
    @CreateDateColumn()
    createdAt: Date;
  
    @UpdateDateColumn()
    updatedAt: Date;
  }
  
  