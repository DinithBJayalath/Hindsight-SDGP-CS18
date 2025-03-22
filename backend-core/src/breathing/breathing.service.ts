import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import {
  BreathingSession,
  BreathingSessionDocument,
} from "./schemas/breathing-session.schema";
import { CreateBreathingSessionDto } from "./dto/create-breathing-session.dto";

@Injectable()
export class BreathingService {
  constructor(
    @InjectModel(BreathingSession.name)
    private breathingSessionModel: Model<BreathingSessionDocument>
  ) {}

  async create(
    createBreathingSessionDto: CreateBreathingSessionDto
  ): Promise<BreathingSession> {
    const createdSession = new this.breathingSessionModel(
      createBreathingSessionDto
    );
    return createdSession.save();
  }

  async findAllByUserId(userId: string): Promise<BreathingSession[]> {
    return this.breathingSessionModel.find({ userId }).exec();
  }

  async findOne(id: string): Promise<BreathingSession> {
    return this.breathingSessionModel.findById(id).exec();
  }

  async remove(id: string): Promise<BreathingSession> {
    return this.breathingSessionModel.findByIdAndDelete(id).exec();
  }
}
