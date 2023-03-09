﻿using Dogo.Core.Enitities;

namespace Dogo.Application.Response
{
    public class PetOwnerResponse
    {
        public Guid Id { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Email { get; set; }
        public string? PhoneNumber { get; set; }
        public Address? Address { get; set; }
    }
}