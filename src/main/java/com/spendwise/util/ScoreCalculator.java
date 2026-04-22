package com.spendwise.util;

import java.math.BigDecimal;

public class ScoreCalculator {

    public static int calculate(
            BigDecimal budget,
            BigDecimal spent,
            int categoryCount,
            int subscriptionCount) {

        int score = 0;

        if (budget.doubleValue() > 0) {
            double ratio = spent.doubleValue() / budget.doubleValue();
            if (ratio <= 0.5)       score += 40;
            else if (ratio <= 0.75) score += 32;
            else if (ratio <= 0.90) score += 22;
            else if (ratio <= 1.0)  score += 12;
            else                    score += 0;
        } else {
            score += 20;
        }

        if (budget.doubleValue() > 0) {
            double saved = 1.0 - (spent.doubleValue() / budget.doubleValue());
            if (saved >= 0.5)      score += 30;
            else if (saved >= 0.3) score += 22;
            else if (saved >= 0.1) score += 14;
            else if (saved >= 0)   score += 6;
        } else {
            score += 15;
        }

        if (categoryCount >= 5)      score += 15;
        else if (categoryCount >= 3) score += 10;
        else if (categoryCount >= 1) score += 5;

        if (subscriptionCount == 0)      score += 15;
        else if (subscriptionCount <= 2) score += 12;
        else if (subscriptionCount <= 4) score += 7;
        else                             score += 2;

        return Math.min(score, 100);
    }

    public static String getGrade(int score) {
        if (score >= 85) return "Excellent";
        if (score >= 70) return "Good";
        if (score >= 55) return "Fair";
        if (score >= 40) return "Needs Work";
        return "Poor";
    }

    public static String getColor(int score) {
        if (score >= 85) return "#2ECC71";
        if (score >= 70) return "#1ABC9C";
        if (score >= 55) return "#E67E22";
        if (score >= 40) return "#E67E22";
        return "#E74C3C";
    }

    public static String getTip(int score) {
        if (score >= 85) return "Amazing! You are managing money like a pro. Keep it up!";
        if (score >= 70) return "Good work! Try to save a little more each month.";
        if (score >= 55) return "Not bad, but watch your subscriptions and big categories.";
        if (score >= 40) return "You are over-spending in some areas. Review your budget.";
        return "Your spending needs attention. Set a budget and track daily.";
    }
}