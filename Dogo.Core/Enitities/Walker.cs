﻿using Dogo.Core.Enums.Tags;

namespace Dogo.Core.Enitities
{
    public class Walker : Person
    {
        public List<Appointment>? Appointments { get; set; }
        public List<Review>? Reviews { get; set; }
        public string? Tags { get; set; }

        public double Rating() => Reviews == null || Reviews.Count == 0 ? 0 : Reviews.Average(r => r.Rating);
    }
}
