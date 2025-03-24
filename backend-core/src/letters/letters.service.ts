import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { Letter, LetterDocument } from "./schemas/letter.schema";
import { CreateLetterDto } from "./dto/create-letter.dto";

@Injectable()
export class LettersService {
  constructor(
    @InjectModel(Letter.name)
    private letterModel: Model<LetterDocument>
  ) {}

  async create(createLetterDto: CreateLetterDto): Promise<Letter> {
    const createdLetter = new this.letterModel(createLetterDto);
    return createdLetter.save();
  }

  async findAllByUserId(userId: string): Promise<Letter[]> {
    return this.letterModel.find({ userId }).exec();
  }

  async findOne(id: string): Promise<Letter> {
    return this.letterModel.findById(id).exec();
  }

  async update(
    id: string,
    updateLetterDto: Partial<CreateLetterDto>
  ): Promise<Letter> {
    return this.letterModel
      .findByIdAndUpdate(id, updateLetterDto, { new: true })
      .exec();
  }

  async remove(id: string): Promise<Letter> {
    return this.letterModel.findByIdAndDelete(id).exec();
  }

  async findLettersToDeliver(): Promise<Letter[]> {
    const now = new Date();
    return this.letterModel
      .find({
        deliveryDate: { $lte: now },
        isDelivered: false,
      })
      .exec();
  }

  async markAsDelivered(id: string): Promise<Letter> {
    return this.letterModel
      .findByIdAndUpdate(id, { isDelivered: true }, { new: true })
      .exec();
  }
}
