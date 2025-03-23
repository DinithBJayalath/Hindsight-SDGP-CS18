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
import { LettersService } from "./letters.service";
import { CreateLetterDto } from "./dto/create-letter.dto";
import { Letter } from "./schemas/letter.schema";

@Controller("letters")
export class LettersController {
  constructor(private readonly lettersService: LettersService) {}

  @Post()
  async create(@Body() createLetterDto: CreateLetterDto): Promise<Letter> {
    return this.lettersService.create(createLetterDto);
  }

  @Get()
  async findAll(@Query("userId") userId: string): Promise<Letter[]> {
    return this.lettersService.findAllByUserId(userId);
  }

  @Get("to-deliver")
  async findLettersToDeliver(): Promise<Letter[]> {
    return this.lettersService.findLettersToDeliver();
  }

  @Get(":id")
  async findOne(@Param("id") id: string): Promise<Letter> {
    return this.lettersService.findOne(id);
  }

  @Put(":id")
  async update(
    @Param("id") id: string,
    @Body() updateLetterDto: Partial<CreateLetterDto>
  ): Promise<Letter> {
    return this.lettersService.update(id, updateLetterDto);
  }

  @Put(":id/deliver")
  async markAsDelivered(@Param("id") id: string): Promise<Letter> {
    return this.lettersService.markAsDelivered(id);
  }

  @Delete(":id")
  async remove(@Param("id") id: string): Promise<Letter> {
    return this.lettersService.remove(id);
  }
}
