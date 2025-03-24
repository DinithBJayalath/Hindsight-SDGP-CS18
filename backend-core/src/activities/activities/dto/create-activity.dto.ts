import { IsString, IsBoolean, IsOptional } from "class-validator";

export class CreateActivityDto {
  @IsString()
  title: string;

  @IsString()
  description: string;

  @IsString()
  icon: string;

  @IsString()
  routeName: string;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}
