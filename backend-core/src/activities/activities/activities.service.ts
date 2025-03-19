import { Injectable } from "@nestjs/common";
import { Activity } from "./interfaces/activity.interface";
import { CreateActivityDto } from "./dto/create-activity.dto";

@Injectable()
export class ActivitiesService {
  private readonly mockActivities: Activity[] = [
    {
      _id: "breathing",
      title: "Deep Breathing",
      description:
        "A guided breathing activity that helps you reduce stress, improve focus, and calm your mind.",
      icon: "🫁",
      routeName: "breathing",
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    },
    {
      _id: "art",
      title: "Drawing Canvas",
      description: "Express yourself through drawing",
      icon: "🎨",
      routeName: "art",
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    },
    {
      _id: "letter",
      title: "Letter to Future Self",
      description: "Write a letter to your future self",
      icon: "✉️",
      routeName: "letter",
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    },
  ];

  async create(createActivityDto: CreateActivityDto): Promise<Activity> {
    const activity = {
      _id: Date.now().toString(),
      ...createActivityDto,
      isActive: createActivityDto.isActive ?? true,
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    this.mockActivities.push(activity);
    return activity;
  }

  async findAll(): Promise<Activity[]> {
    return this.mockActivities;
  }

  async findOne(id: string): Promise<Activity> {
    return this.mockActivities.find((activity) => activity._id === id);
  }

  async update(
    id: string,
    updateActivityDto: Partial<CreateActivityDto>
  ): Promise<Activity> {
    const activity = await this.findOne(id);
    if (!activity) return null;

    Object.assign(activity, updateActivityDto, { updatedAt: new Date() });
    return activity;
  }

  async remove(id: string): Promise<Activity> {
    const index = this.mockActivities.findIndex(
      (activity) => activity._id === id
    );
    if (index === -1) return null;

    return this.mockActivities.splice(index, 1)[0];
  }
}
