import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { Activity } from "../schemas/activity.schema";

@Injectable()
export class ActivitiesSeedService {
  constructor(
    @InjectModel(Activity.name)
    private activityModel: Model<Activity>
  ) {}

  async seed() {
    const activities = [
      {
        _id: "breathing",
        title: "Deep Breathing",
        description:
          "A guided breathing activity that helps you reduce stress, improve focus, and calm your mind.",
        icon: "self_improvement",
        routeName: "/breathing",
        isActive: true,
      },
      {
        _id: "art",
        title: "Expressive Art",
        description:
          "A digital canvas for you to draw or doodle your emotions.",
        icon: "palette",
        routeName: "/art",
        isActive: true,
      },
      {
        _id: "letter",
        title: "Letter to Future Self",
        description:
          "Write a letter to yourself, set a future date, and receive the letter as a reminder.",
        icon: "mail",
        routeName: "/letters",
        isActive: true,
      },
    ];

    try {
      // Clear existing activities
      await this.activityModel.deleteMany({});

      // Insert new activities
      await this.activityModel.insertMany(activities);

      console.log("Activities seeded successfully");
    } catch (error) {
      console.error("Error seeding activities:", error);
      throw error;
    }
  }
}
