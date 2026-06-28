using AutoMapper;
using AlexandriaMobilityPlatform.Domain.Entities;
using AlexandriaMobilityPlatform.Application.DTOs.Auth;
using AlexandriaMobilityPlatform.Application.DTOs.Vehicle;
using AlexandriaMobilityPlatform.Application.DTOs.Notification;
using AlexandriaMobilityPlatform.Application.DTOs.Route;
using AlexandriaMobilityPlatform.Application.DTOs.User;

namespace AlexandriaMobilityPlatform.Application.Mappings;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        CreateMap<ApplicationUser, UserProfileDto>()
            .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
            .ForMember(dest => dest.FullName, opt => opt.MapFrom(src => src.FullName))
            .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Email!))
            .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.PhoneNumber!))
            .ForMember(dest => dest.ProfileImageUrl, opt => opt.MapFrom(src => src.ProfileImageUrl))
            .ForMember(dest => dest.PreferredLanguage, opt => opt.MapFrom(src => src.PreferredLanguage ?? "en"));

        CreateMap<ApplicationUser, UserDto>()
            .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
            .ForMember(dest => dest.FullName, opt => opt.MapFrom(src => src.FullName))
            .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Email!))
            .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.PhoneNumber!))
            .ForMember(dest => dest.Role, opt => opt.MapFrom(_ => "Passenger"))
            .ForMember(dest => dest.ProfileImageUrl, opt => opt.MapFrom(src => src.ProfileImageUrl))
            .ForMember(dest => dest.PreferredLanguage, opt => opt.MapFrom(src => src.PreferredLanguage ?? "en"))
            .ForMember(dest => dest.IsActive, opt => opt.MapFrom(src => src.IsActive))
            .ForMember(dest => dest.CreatedAt, opt => opt.MapFrom(_ => DateTime.UtcNow));

        CreateMap<Stop, StopDto>()
            .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
            .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Name))
            .ForMember(dest => dest.Latitude, opt => opt.MapFrom(src => src.Latitude))
            .ForMember(dest => dest.Longitude, opt => opt.MapFrom(src => src.Longitude))
            .ForMember(dest => dest.OrderNumber, opt => opt.MapFrom(src => src.OrderNumber))
            .ForMember(dest => dest.EstimatedArrivalMinutes, opt => opt.MapFrom(src => src.EstimatedArrivalMinutes));

        CreateMap<Vehicle, VehicleDto>()
            .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
            .ForMember(dest => dest.DriverId, opt => opt.MapFrom(src => src.DriverId))
            .ForMember(dest => dest.DriverName, opt => opt.MapFrom(src => src.Driver != null ? src.Driver.FullName : ""))
            .ForMember(dest => dest.PlateNumber, opt => opt.MapFrom(src => src.PlateNumber))
            .ForMember(dest => dest.Model, opt => opt.MapFrom(src => src.Model))
            .ForMember(dest => dest.Color, opt => opt.MapFrom(src => src.Color ?? ""))
            .ForMember(dest => dest.Capacity, opt => opt.MapFrom(src => src.Capacity))
            .ForMember(dest => dest.Year, opt => opt.MapFrom(src => src.Year))
            .ForMember(dest => dest.IsActive, opt => opt.MapFrom(src => src.IsActive));

        CreateMap<Notification, NotificationDto>()
            .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
            .ForMember(dest => dest.Title, opt => opt.MapFrom(src => src.Title))
            .ForMember(dest => dest.Message, opt => opt.MapFrom(src => src.Message))
            .ForMember(dest => dest.Type, opt => opt.MapFrom(src => src.Type.ToString()))
            .ForMember(dest => dest.IsRead, opt => opt.MapFrom(src => src.IsRead))
            .ForMember(dest => dest.CreatedAt, opt => opt.MapFrom(src => src.CreatedAt.DateTime));

        CreateMap<Domain.Entities.Route, RouteDto>()
            .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
            .ForMember(dest => dest.CommunityId, opt => opt.MapFrom(src => src.CommunityId))
            .ForMember(dest => dest.CommunityName, opt => opt.MapFrom(src => src.Community != null ? src.Community.Name : ""))
            .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Name))
            .ForMember(dest => dest.StartPoint, opt => opt.MapFrom(src => src.StartPoint))
            .ForMember(dest => dest.EndPoint, opt => opt.MapFrom(src => src.EndPoint))
            .ForMember(dest => dest.StartLatitude, opt => opt.MapFrom(src => src.StartLatitude))
            .ForMember(dest => dest.StartLongitude, opt => opt.MapFrom(src => src.StartLongitude))
            .ForMember(dest => dest.EndLatitude, opt => opt.MapFrom(src => src.EndLatitude))
            .ForMember(dest => dest.EndLongitude, opt => opt.MapFrom(src => src.EndLongitude))
            .ForMember(dest => dest.DistanceKm, opt => opt.MapFrom(src => src.DistanceKm))
            .ForMember(dest => dest.EstimatedTimeMinutes, opt => opt.MapFrom(src => src.EstimatedTimeMinutes))
            .ForMember(dest => dest.Stops, opt => opt.MapFrom(src => src.Stops))
            .ForMember(dest => dest.IsActive, opt => opt.MapFrom(src => src.IsActive));
    }
}
