using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace iot_data_processor.Validators
{
    internal class ContainerValidator : IValidator
    {
        public bool Validate(SensorData data)
        {
            return true;
        }

    }
}
