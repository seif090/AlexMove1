using AlexandriaMobilityPlatform.Application.Common.Interfaces;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using MimeKit;

namespace AlexandriaMobilityPlatform.Infrastructure.Services;

public class EmailSettings
{
    public string From { get; set; } = "";
    public string FromName { get; set; } = "Alexandria Mobility";
    public string SmtpServer { get; set; } = "";
    public int Port { get; set; } = 587;
    public string Username { get; set; } = "";
    public string Password { get; set; } = "";
    public bool EnableSsl { get; set; } = true;
}

public class EmailService : IEmailService
{
    private readonly EmailSettings _settings;
    private readonly ILogger<EmailService> _logger;

    public EmailService(IOptions<EmailSettings> settings, ILogger<EmailService> logger)
    {
        _settings = settings.Value;
        _logger = logger;
    }

    public async Task SendAsync(string to, string subject, string htmlBody, CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrEmpty(_settings.SmtpServer))
        {
            _logger.LogWarning("Email service not configured. Skipping email to {To} with subject {Subject}", to, subject);
            return;
        }

        try
        {
            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(_settings.FromName, _settings.From));
            message.To.Add(MailboxAddress.Parse(to));
            message.Subject = subject;

            var bodyBuilder = new BodyBuilder { HtmlBody = htmlBody };
            message.Body = bodyBuilder.ToMessageBody();

            using var client = new SmtpClient();
            var secureSocketOptions = _settings.EnableSsl ? SecureSocketOptions.StartTls : SecureSocketOptions.None;
            await client.ConnectAsync(_settings.SmtpServer, _settings.Port, secureSocketOptions, cancellationToken);
            await client.AuthenticateAsync(_settings.Username, _settings.Password, cancellationToken);
            await client.SendAsync(message, cancellationToken);
            await client.DisconnectAsync(true, cancellationToken);

            _logger.LogInformation("Email sent to {To} with subject {Subject}", to, subject);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to send email to {To} with subject {Subject}", to, subject);
        }
    }

    public async Task SendTemplatedAsync(string to, string templateName, object model, CancellationToken cancellationToken = default)
    {
        var htmlBody = BuildTemplateHtml(templateName, model);
        await SendAsync(to, templateName, htmlBody, cancellationToken);
    }

    private static string BuildTemplateHtml(string templateName, object model)
    {
        var properties = model.GetType().GetProperties();
        var content = "";
        foreach (var prop in properties)
        {
            var value = prop.GetValue(model)?.ToString() ?? "";
            content += $"<p><strong>{prop.Name}:</strong> {value}</p>";
        }

        return $"""
            <!DOCTYPE html>
            <html>
            <head><meta charset="utf-8"></head>
            <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
                <div style="background: linear-gradient(135deg, #6366f1, #8b5cf6); padding: 20px; border-radius: 12px; text-align: center;">
                    <h1 style="color: white; margin: 0;">Alexandria Mobility</h1>
                </div>
                <div style="padding: 20px; background: #f9fafb; border-radius: 0 0 12px 12px;">
                    <h2>{templateName}</h2>
                    {content}
                </div>
                <div style="text-align: center; padding: 16px; color: #9ca3af; font-size: 12px;">
                    <p>Alexandria Community Mobility Platform</p>
                </div>
            </body>
            </html>
            """;
    }
}
