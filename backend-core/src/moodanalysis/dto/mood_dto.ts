import { IsString, IsOptional, IsDateString } from 'class-validator';

export class CreateMoodDto {
  @IsString()
  userId: string;

  @IsString()
  mood: string;

  @IsOptional()
  @IsDateString()
  date?: string;

  @IsOptional()
  @IsString()
  note?: string;
}