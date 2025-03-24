import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  Query,
} from "@nestjs/common";
import { BreathingService } from "./breathing.service";
import { CreateBreathingSessionDto } from "./dto/create-breathing-session.dto";
import { BreathingSession } from "./schemas/breathing-session.schema";

@Controller("breathing")
export class BreathingController {
  constructor(private readonly breathingService: BreathingService) {}

  @Post()
  async create(
    @Body() createBreathingSessionDto: CreateBreathingSessionDto
  ): Promise<BreathingSession> {
    return this.breathingService.create(createBreathingSessionDto);
  }

  @Get()
  async findAll(@Query("userId") userId: string): Promise<BreathingSession[]> {
    return this.breathingService.findAllByUserId(userId);
  }

  @Get(":id")
  async findOne(@Param("id") id: string): Promise<BreathingSession> {
    return this.breathingService.findOne(id);
  }

  @Delete(":id")
  async remove(@Param("id") id: string): Promise<BreathingSession> {
    return this.breathingService.remove(id);
  }
}
