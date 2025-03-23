import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Put,
  Delete,
  Query,
} from "@nestjs/common";
import { DrawingsService } from "./drawings.service";
import { CreateDrawingDto } from "./dto/create-drawing.dto";
import { Drawing } from "./schemas/drawing.schema";

@Controller("drawings")
export class DrawingsController {
  constructor(private readonly drawingsService: DrawingsService) {}

  @Post()
  async create(@Body() createDrawingDto: CreateDrawingDto): Promise<Drawing> {
    return this.drawingsService.create(createDrawingDto);
  }

  @Get()
  async findAll(@Query("userId") userId: string): Promise<Drawing[]> {
    return this.drawingsService.findAllByUserId(userId);
  }

  @Get(":id")
  async findOne(@Param("id") id: string): Promise<Drawing> {
    return this.drawingsService.findOne(id);
  }

  @Put(":id")
  async update(
    @Param("id") id: string,
    @Body() updateDrawingDto: Partial<CreateDrawingDto>
  ): Promise<Drawing> {
    return this.drawingsService.update(id, updateDrawingDto);
  }

  @Delete(":id")
  async remove(@Param("id") id: string): Promise<Drawing> {
    return this.drawingsService.remove(id);
  }
}
