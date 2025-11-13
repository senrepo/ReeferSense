using Microsoft.EntityFrameworkCore;
using reefersense_data.Models.StoredProcedures;
    
namespace reefersense_data.Context
{
    public class ReeferSenseDbContext : DbContext
    {
        public ReeferSenseDbContext(DbContextOptions<ReeferSenseDbContext> options)
            : base(options)
        {
        }

        // Keyless query types mapped to stored procedure result sets
        public DbSet<CompanyGetResult> Companies => Set<CompanyGetResult>();
        public DbSet<CompanyModemGetResult> CompanyModems => Set<CompanyModemGetResult>();
        public DbSet<CompanyVesselGetResult> CompanyVessels => Set<CompanyVesselGetResult>();
        public DbSet<TemperatureDataLatestResult> TemperatureDataLatestResults { get; set; }
        //public DbSet<ContainerGetResult> Containers => Set<ContainerGetResult>();
        //public DbSet<ModemGetResult> Modems => Set<ModemGetResult>();
        //public DbSet<ModemFirmwareGetResult> ModemFirmwares => Set<ModemFirmwareGetResult>();
        //public DbSet<UserGetResult> Users => Set<UserGetResult>();
        //public DbSet<ValidateContainerModemResult> ValidateContainerModems => Set<ValidateContainerModemResult>();
        //public DbSet<VesselGetResult> Vessels => Set<VesselGetResult>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // All of these are keyless entities (stored procedure result sets)
            modelBuilder.Entity<CompanyGetResult>(entity =>
            {
                entity.HasNoKey();
                entity.ToView(null);
            });

            modelBuilder.Entity<CompanyModemGetResult>(entity =>
            {
                entity.HasNoKey();
                entity.ToView(null);
            });

            modelBuilder.Entity<CompanyVesselGetResult>(entity =>
            {
                entity.HasNoKey();
                entity.ToView(null);
            });

            //modelBuilder.Entity<ContainerGetResult>(entity =>
            //{
            //    entity.HasNoKey();
            //    entity.ToView(null);
            //});

            //modelBuilder.Entity<ModemGetResult>(entity =>
            //{
            //    entity.HasNoKey();
            //    entity.ToView(null);
            //});

            //modelBuilder.Entity<ModemFirmwareGetResult>(entity =>
            //{
            //    entity.HasNoKey();
            //    entity.ToView(null);
            //});

            //modelBuilder.Entity<UserGetResult>(entity =>
            //{
            //    entity.HasNoKey();
            //    entity.ToView(null);
            //});

            //modelBuilder.Entity<ValidateContainerModemResult>(entity =>
            //{
            //    entity.HasNoKey();
            //    entity.ToView(null);
            //});

            //modelBuilder.Entity<VesselGetResult>(entity =>
            //{
            //    entity.HasNoKey();
            //    entity.ToView(null);
            //});

            modelBuilder.Entity<TemperatureDataLatestResult>(entity =>
            {
                entity.HasNoKey();
                entity.ToView(null);

                entity.Property(p => p.CompanyName).HasColumnName("company_name");
                entity.Property(p => p.VesselId).HasColumnName("vessel_id");
                entity.Property(p => p.VesselName).HasColumnName("vessel_name");
                entity.Property(p => p.ContainerId).HasColumnName("container_id");
                entity.Property(p => p.ModemImei).HasColumnName("modem_imei");
                entity.Property(p => p.Model).HasColumnName("model");
                entity.Property(p => p.Manufacturer).HasColumnName("manufacturer");
                entity.Property(p => p.FirmwareVersion).HasColumnName("firmware_version");
                entity.Property(p => p.TemperatureF).HasColumnName("temperatureF");
                entity.Property(p => p.Co2Percent).HasColumnName("co2_percent");
                entity.Property(p => p.Deforsting).HasColumnName("deforsting");
                entity.Property(p => p.HumidityPercent).HasColumnName("humidityPercent");
                entity.Property(p => p.O2Percent).HasColumnName("o2_percent");
                entity.Property(p => p.Power).HasColumnName("power");
                entity.Property(p => p.LoggedAt).HasColumnName("logged_dt");
                entity.Property(p => p.ReceivedAt).HasColumnName("received_dt");
            });

            base.OnModelCreating(modelBuilder);
        }
    }
}
