using Autofac;
using Autofac.Extensions.DependencyInjection;
using Business.Abstract;
using Business.Concrete;
using Business.DependencyResolvers.Autofac;
using Core.Utilities.IoC;
using Core.DependencyResolvers;
using Core.Utilities.Security.Encryption;
using Core.Extensions;
using Core.Utilities.Security.JWT;
using DataAccess.Abstract;
using DataAccess.Concrete.EntityFramework;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using DataAccess.Concrete.EntityFramework;
using Microsoft.EntityFrameworkCore;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
//builder.Services.AddSingleton<IProductService, ProductManager>();
//builder.Services.AddSingleton<IProductDal, EfProductDal>();

// 1) CORS Servisini Ekle
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins", policyBuilder =>
    {
        // Geliştirme aşamasında geçici olarak herkese izin
        policyBuilder
            .AllowAnyOrigin()    // production'da *geniş* izin vermek yerine belirli bir domain kullanmanız önerilir
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

// AppDbContext'i ekle
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));


var tokenOptions = builder.Configuration.GetSection("TokenOptions").Get<TokenOptions>();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidIssuer = tokenOptions.Issuer,
            ValidAudience = tokenOptions.Audience,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = SecurityKeyHelper.CreateSecurityKey(tokenOptions.SecurityKey)
        };
    });

builder.Services.AddDependencyResolvers(new ICoreModule[]
{
    new CoreModule()
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Host.UseServiceProviderFactory(services => new AutofacServiceProviderFactory()).ConfigureContainer<ContainerBuilder>(builder => { builder.RegisterModule(new AutofacBusinessModule()); });

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAllOrigins");

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run("http://165.232.76.61:5000");