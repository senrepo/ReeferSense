using Microsoft.EntityFrameworkCore;
using reefersense_data.Context;
using reefersense_data.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

// 1. Connection string from appsettings.json
var connectionString = builder.Configuration.GetConnectionString("ReeferSenseDb");
// 2. Register DbContext
builder.Services.AddDbContext<ReeferSenseDbContext>(options =>
    options.UseSqlServer(connectionString));
// 3. Register repositories
builder.Services.AddScoped<IReeferSenseRepository, ReeferSenseRepository>();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
