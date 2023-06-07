﻿using Dogo.Application.Commands.Appointment;
using Dogo.Application.Queries.Appointment;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Dogo.API.Controllers
{
    [Route("api/v{version:apiVersion}/appointments")]
    [ApiController]
    [ApiVersion("1.0")]
    public class AppointmentsController : ControllerBase
    {
        private readonly IMediator _medator;

        public AppointmentsController(IMediator medator) => _medator = medator;

        // Work with appoitments
        // Done - GetAll, GetByID, Create, Delete, Update
        // Work in progress - 

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateAppointmentCommand command)
        {
            var result = await _medator.Send(command);
            return result.IsSuccess 
                ? Created(nameof(GetById), result.Entity) 
                : StatusCode((int)result.StatusCode, result.Message);
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var result = await _medator.Send(new GetAllAppointmentsQuery());
            return result.IsSuccess
                ? Ok(result.Entity)
                : StatusCode((int)result.StatusCode, result.Message);
        }

        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetByOwner(Guid userId)
        {
            var result = await _medator.Send(new GetAppointmentsOfOwnerQuery(){ UserId = userId });
            return result.IsSuccess
                ? Ok(result.Entity)
                : StatusCode((int)result.StatusCode, result.Message);
        }

        [HttpGet("{id:Guid}")]
        public async Task<IActionResult> GetById([FromRoute] Guid id)
        {
            var result = await _medator.Send(new GetAppointmentByIdQuery { Id = id });
            return result.IsSuccess
                ? Ok(result.Entity)
                : StatusCode((int)result.StatusCode, result.Message);
        }

        [HttpGet("available")]
        public async Task<IActionResult> GetAvailable([FromQuery] GetAvailableAppointmentsQuery query)
        {
            var result = await _medator.Send(query);
            return result.IsSuccess
                ? Ok(result.Entity)
                : StatusCode((int)result.StatusCode, result.Message);
        }

        [HttpGet("agenda")]
        public async Task<IActionResult> GetAgenda([FromQuery] GetAgendaOfUserQuery query)
        {
            var result = await _medator.Send(query);
            return result.IsSuccess
                ? Ok(result.Entity)
                : StatusCode((int)result.StatusCode, result.Message);
        }

        [HttpPut("assign")]
        public async Task<IActionResult> Accept([FromQuery] AssignAppointmentQuery command)
        {
            var result = await _medator.Send(command);
            return result.IsSuccess
                ? NoContent()
                : StatusCode((int)result.StatusCode, result.Message);
        }

        [HttpPut("{id:Guid}")]
        public async Task<IActionResult> Update([FromRoute] Guid id, [FromBody] UpdateAppointmentCommand command)
        {
            var result = await _medator.Send(new UpdateAppointmentQuery { Id = id, Appointment = command});
            return result.IsSuccess
                ? NoContent()
                : StatusCode((int)result.StatusCode, result.Message);
        }

        [HttpDelete("{id:Guid}")]
        public async Task<IActionResult> Delete([FromRoute] Guid id)
        {
            var result = await _medator.Send(new DeleteAppointmentQuery { Id = id });
            return result.IsSuccess
                ? NoContent()
                : StatusCode((int)result.StatusCode, result.Message);
        }
    }
}
