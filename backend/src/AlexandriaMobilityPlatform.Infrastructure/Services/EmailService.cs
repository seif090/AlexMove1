using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class EmailSettings { public string From { get; set; } = ""; public string SmtpServer { get; set; } = ""; public int Port { get; set; } = 587; public string Username { get; set; } = ""; public string Password { get; set; } = ""; }

public class EmailService : IEmailService
{
    private readonly EmailSettings _settings;
    private readonly ILogger<EmailService> _logger;
    public EmailService(IOptions<EmailSettings> settings, ILogger<EmailService> logger) { _settings = settings.Value; _logger = logger; }
    public async Task SendAsync(string to, string subject, string htmlBody, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Sending email to {To} with subject {Subject}", to, subject);
        // In production use MailKit: var message = new MimeMessage(); ...
        await Task.CompletedTask;
    }
    public async Task SendTemplatedAsync(string to, string templateName, object model, CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Sending templated email {Template} to {To}", templateName, to);
        await Task.CompletedTask;
    }
}
