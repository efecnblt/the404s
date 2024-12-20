using Business.Abstract;
using Business.Constants;
using Core.Aspects.Autofac.Transaction;
using Core.Entities.Concrete;
using Core.Utilities.Results;
using Core.Utilities.Security.Hashing;
using Core.Utilities.Security.JWT;
using Entities.Concrete;
using Entities.DTOs;
using Microsoft.VisualBasic;
using System.Transactions;

namespace Business.Concrete
{
    public class AuthManager : IAuthService
    {
        private IUserService _userService;
        private ITokenHelper _tokenHelper;
        private IOperationClaimService _operationClaimService;
        private IUserOperationClaimService _userOperationClaimService;
        private IAuthorService _authorService;
        private IStudentService _studentService;


        public AuthManager(IUserService userService, 
                            ITokenHelper tokenHelper,
                            IOperationClaimService operationClaimService,
                            IUserOperationClaimService userOperationClaimService,
                            IAuthorService authorService,
                            IStudentService studentService)
        {
            _userService = userService;
            _tokenHelper = tokenHelper;
            _operationClaimService = operationClaimService;
            _userOperationClaimService = userOperationClaimService;
            _authorService = authorService;
            _studentService = studentService;
        }

        [TransactionScopeAspect]
        public IDataResult<User> Register(UserForRegisterDto userForRegisterDto, string password)
        {
            using (TransactionScope scope = new TransactionScope())
            {
                try
                {
                    byte[] passwordHash, passwordSalt;
                    HashingHelper.CreatePasswordHash(password, out passwordHash, out passwordSalt);

                    var user = new User
                    {
                        Email = userForRegisterDto.Email,
                        FirstName = userForRegisterDto.FirstName,
                        LastName = userForRegisterDto.LastName,
                        PasswordHash = passwordHash,
                        PasswordSalt = passwordSalt,
                        Status = true
                    };

                    _userService.Add(user); // User tablosuna ekle

                    var operationClaim = _operationClaimService.GetByName(userForRegisterDto.Role);
                    if (operationClaim == null)
                        return new ErrorDataResult<User>("Invalid role");

                    _userOperationClaimService.Add(new UserOperationClaim
                    {
                        UserId = user.Id,
                        OperationClaimId = operationClaim.Id
                    });

                    Console.WriteLine($"User added. UserId: {user.Id}");

                    System.Diagnostics.Debug.WriteLine("UserID to be added to Students table: " + user.Id);

                    // Role'e göre ekleme işlemi
                    if (userForRegisterDto.Role == "Student")
                    {

                        System.Diagnostics.Debug.WriteLine("UserID to be added to Students table: " + user.Id);


                        _studentService.Add(new Student
                        {
                            UserId = user.Id,
                            EnrollmentDate = DateTime.Now,
                            
                        });
                    }
                    else if (userForRegisterDto.Role == "Author")
                    {
                        _authorService.Add(new Author
                        {
                            Name = $"{user.FirstName} {user.LastName}",
                            Rating = 0,
                            StudentCount = 0,
                            CourseCount = 0
                        });
                    }

                    scope.Complete(); // Tüm işlemler başarılıysa commit
                    return new SuccessDataResult<User>(user, "User registered successfully");
                }
                catch (Exception ex)
                {
                    scope.Dispose(); // Hata durumunda rollback
                    return new ErrorDataResult<User>("Registration failed: " + ex.Message);
                }
            }
        }





        public IDataResult<User> Login(UserForLoginDto userForLoginDto)
        {
            var userToCheck = _userService.GetByMail(userForLoginDto.Email);
            if (userToCheck == null)
            {
                return new ErrorDataResult<User>(Messages.UserNotFound);
            }

            if (!HashingHelper.VerifyPasswordHash(userForLoginDto.Password, userToCheck.PasswordHash, userToCheck.PasswordSalt))
            {
                return new ErrorDataResult<User>(Messages.PasswordError);
            }

            return new SuccessDataResult<User>(userToCheck, Messages.SuccessfulLogin);
        }

        public IResult UserExists(string email)
        {
            if (_userService.GetByMail(email) != null)
            {
                return new ErrorResult(Messages.UserAlreadyExists);
            }
            return new SuccessResult();
        }

        public IDataResult<AccessToken> CreateAccessToken(User user)
        {
            var claims = _userService.GetClaims(user);
            var accessToken = _tokenHelper.CreateToken(user, claims);
            return new SuccessDataResult<AccessToken>(accessToken, Messages.AccessTokenCreated);
        }
    }
}
