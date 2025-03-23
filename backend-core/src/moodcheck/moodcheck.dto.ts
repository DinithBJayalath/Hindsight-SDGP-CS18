import { IsString, IsArray, IsNotEmpty, IsOptional, IsBoolean, IsNumber } from 'class-validator';

export class MoodCheckDto {
    @IsString()
    @IsNotEmpty()
    mood: string;

    @IsString()
    @IsNotEmpty()
    emotion: string;

    @IsArray()
    @IsOptional()
    factors: string[] = [];

    @IsBoolean()
    @IsOptional()
    isJournal: boolean = false;

    @IsString()
    @IsOptional()
    journalTitle: string;

    @IsString()
    @IsOptional()
    journalContent: string;

    @IsNumber()
    @IsOptional()
    sentiment: number;
}