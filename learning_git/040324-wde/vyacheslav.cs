using System;
using System.IO;
using Google.Apis.Services;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Gmail.v1;
using System.Threading;
using Google.Apis.Util.Store;
using System.Security.Cryptography.X509Certificates;
using MimeKit;
using Google.Apis.Gmail.v1.Data;
using System.Collections.Generic;

namespace GmailApiTests.GUI
{
    internal class GoogleApiClient
    {
        internal UserCredential AuthenticateAsUser(string keyFilePath, string[] scopes)
        {
            if (string.IsNullOrEmpty(keyFilePath))
                throw new ArgumentNullException("Path to the user account credentials file is required.");


            if (!System.IO.File.Exists(keyFilePath))
                throw new ArgumentNullException("The user account credentials file does not exist at: " + keyFilePath);

            try
            {
                // These are the scopes of permissions you need. It is best to request only what you need and not all of them               
                using (FileStream stream = new FileStream(keyFilePath, FileMode.Open, FileAccess.Read))
                {
                    string credPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Personal);
                    credPath = Path.Combine(credPath, ".credentials/", System.Reflection.Assembly.GetExecutingAssembly().GetName().Name);

                    // Requesting Authentication or loading previously stored authentication for userName
                    UserCredential credential = GoogleWebAuthorizationBroker.AuthorizeAsync(GoogleClientSecrets.Load(stream).Secrets,
                        scopes,
                        "user",
                        CancellationToken.None,
                        new FileDataStore(credPath, true)).Result;

                    credential.GetAccessTokenForRequestAsync();
                    return credential;
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal GoogleCredential GetServiceAccountCredentials(string keyFilePath, string[] scopes, string serviceAccountEmail, string impersonateUserEmail)
        {
            if (string.IsNullOrEmpty(keyFilePath))
                throw new ArgumentNullException("Path to the service account credentials file is required.");

            if (!System.IO.File.Exists(keyFilePath))
                throw new ArgumentNullException("The service account credentials file does not exist at: " + keyFilePath);

            try
            {
                if (Path.GetExtension(keyFilePath).ToLower() == ".json")
                    return GoogleCredential.FromFile(keyFilePath).CreateScoped(scopes).CreateWithUser(impersonateUserEmail);

                if (Path.GetExtension(keyFilePath).ToLower() == ".p12")
                {
                    X509Certificate2 certificate = new X509Certificate2(keyFilePath, "notasecret", X509KeyStorageFlags.MachineKeySet | X509KeyStorageFlags.Exportable);
                    ServiceAccountCredential serviceAccontCredential = new ServiceAccountCredential(new ServiceAccountCredential.Initializer(serviceAccountEmail)
                    {
                        Scopes = scopes,
                        User = impersonateUserEmail
                    }.FromCertificate(certificate));
                    return GoogleCredential.FromServiceAccountCredential(serviceAccontCredential);
                }

                throw new Exception("Unsupported Service accounts credentials.");
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        //internal GmailService CreateGmailService(string keyFilePath, string serviceAccountEmail, string impersonateUser)
        internal GmailService CreateGmailService(string keyFilePath)
        {
            GmailService resultGmailService = null;
            string[] scopes = { GmailService.Scope.GmailCompose, GmailService.Scope.GmailSend };
            try
            {
                //var credential = GetServiceAccountCredentials(keyFilePath, scopes, serviceAccountEmail, impersonateUser);
                var credential = AuthenticateAsUser(keyFilePath, scopes);
                if (credential != null)
                {
                    resultGmailService = new GmailService(new BaseClientService.Initializer
                    {
                        ApplicationName = "OMGmailAPI",
                        HttpClientInitializer = credential
                    });

                }
            }
            catch (Exception e)
            {
                throw e;
            }

            return resultGmailService;
        }

        internal Message sendMessage(GmailService gmailService, string ToEmail, string ToFullName, string FromEmail, string FromFullName, string Subject, string BodyText, List<string> Attachments)
        {
            var builder = new BodyBuilder();
            var message = new MimeMessage();
            message.Date = DateTime.Now;
            message.From.Add(new MailboxAddress(FromFullName, FromEmail));
            message.To.Add(new MailboxAddress(ToFullName, ToEmail));
            message.ReplyTo.Add(new MailboxAddress(FromFullName, FromEmail));
            message.Subject = Subject;
            builder.HtmlBody = BodyText;
            builder.TextBody = BodyText;
            message.Priority = MessagePriority.Normal;
            if (Attachments != null)
            {
                foreach (var itemAttachment in Attachments)
                {
                    builder.Attachments.Add(itemAttachment);
                }
            }
            message.Body = builder.ToMessageBody();

            var gmailMessage = new Google.Apis.Gmail.v1.Data.Message
            {
                Raw = Base64Encode(message)
            };

            var result = gmailService.Users.Messages.Send(gmailMessage, "me").Execute();
           
            return result;
        }

        internal string Base64Encode(MimeMessage mimeMessage)
        {
            string result;
            using (var stream = new MemoryStream())
            {
                mimeMessage.WriteTo(stream);

                var buffer = stream.ToArray();
                var base64 = Convert.ToBase64String(buffer)
                    .Replace('+', '-')
                    .Replace('/', '_')
                    .Replace("=", "");

                result = base64;
            }
            return result;
        }

        
}
}