// // src/profile/dto/update-profile.dto.ts
// import { IsOptional, IsString, IsBoolean, IsDate, IsISO8601 } from 'class-validator';
// import { Transform } from 'class-transformer';

// export class UpdateProfileDto {
//   @IsOptional()
//   @IsString()
//   name?: string;

//   @IsOptional()
//   @IsISO8601()
//   @Transform(({ value }) => value ? new Date(value) : undefined)
//   dateOfBirth?: Date;

//   @IsOptional()
//   @IsString()
//   country?: string;

//   @IsOptional()
//   @IsString()
//   city?: string;

//   @IsOptional()
//   @IsString()
//   bio?: string;

//   @IsOptional()
//   @IsBoolean()
//   biometricAuthentication?: boolean;

//   @IsOptional()
//   @IsBoolean()
//   cloudBackup?: boolean;

//   @IsOptional()
//   @IsBoolean()
//   pushNotifications?: boolean;

//   @IsOptional()
//   @IsString()
//   language?: string;
// }