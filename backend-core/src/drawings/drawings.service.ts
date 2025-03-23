import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { Drawing, DrawingDocument } from "./schemas/drawing.schema";
import { CreateDrawingDto } from "./dto/create-drawing.dto";

@Injectable()
export class DrawingsService {
  constructor(
    @InjectModel(Drawing.name)
    private drawingModel: Model<DrawingDocument>
  ) {}

  async create(createDrawingDto: CreateDrawingDto): Promise<Drawing> {
    const createdDrawing = new this.drawingModel(createDrawingDto);
    return createdDrawing.save();
  }

  async findAllByUserId(userId: string): Promise<Drawing[]> {
    return this.drawingModel.find({ userId }).exec();
  }

  async findOne(id: string): Promise<Drawing> {
    return this.drawingModel.findById(id).exec();
  }

  async update(
    id: string,
    updateDrawingDto: Partial<CreateDrawingDto>
  ): Promise<Drawing> {
    return this.drawingModel
      .findByIdAndUpdate(id, updateDrawingDto, { new: true })
      .exec();
  }

  async remove(id: string): Promise<Drawing> {
    return this.drawingModel.findByIdAndDelete(id).exec();
  }
}
