import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { Activity, ActivityDocument } from "./schemas/activity.schema";
import { CreateActivityDto } from "./dto/create-activity.dto";

@Injectable()
export class ActivitiesService {
  constructor(
    @InjectModel(Activity.name)
    private activityModel: Model<ActivityDocument>
  ) {}

  async create(createActivityDto: CreateActivityDto): Promise<Activity> {
    const createdActivity = new this.activityModel(createActivityDto);
    return createdActivity.save();
  }

  async findAll(): Promise<Activity[]> {
    return this.activityModel.find().exec();
  }

  async findOne(id: string): Promise<Activity> {
    return this.activityModel.findById(id).exec();
  }

  async update(
    id: string,
    updateActivityDto: Partial<CreateActivityDto>
  ): Promise<Activity> {
    return this.activityModel
      .findByIdAndUpdate(id, updateActivityDto, { new: true })
      .exec();
  }

  async remove(id: string): Promise<Activity> {
    return this.activityModel.findByIdAndDelete(id).exec();
  }
}
