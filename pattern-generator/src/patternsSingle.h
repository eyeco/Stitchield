/*---------------------------------------------------------------------------------------------
* Copyright (C) 2024 eyeco https://github.com/eyeco https://www.rolandaigner.com
* This file is part of patgen
*
* Licensed under the GPL3 License. See LICENSE file in the repository root for license information.
*
* You should have received a copy of the GNU General Public License
* along with this code. If not, see < http://www.gnu.org/licenses/>.
*--------------------------------------------------------------------------------------------*/


#pragma once

#include <pattern.h>

namespace patgen
{
	class BoustrophedonCircle : public Pattern
	{
	private:
		float _diameter;
		float _dist;
		float _rMax;

		virtual void clear();

		virtual void updateSizeString();

	public:
		class PatternParams : public PatternParamsBase
		{
		public:
			float _diameter;

			PatternParams() :
				PatternParamsBase(),
				_diameter( 10 )
			{}

			virtual bool drawUI();
		};


		BoustrophedonCircle();
		virtual ~BoustrophedonCircle();

		virtual bool build( const PatternParamsBase* params );
		virtual std::string getFullName() const;
	};

	class SpiralCircle : public Pattern
	{
	private:
		float _diameter;
		float _dist;
		float _innerDiameter;

		float _innerStitchLength;

		glm::vec3 _first;
		glm::vec3 _last;

		virtual void clear();

		virtual void updateSizeString();

	public:
		class PatternParams : public PatternParamsBase
		{
		public:
			float _diameter;
			float _innerDiameter;
			float _innerStitchLength;

			PatternParams() :
				PatternParamsBase(),
				_diameter( 10 ),
				_innerDiameter( 0 ),
				_innerStitchLength( 0.1f )
			{}

			virtual bool drawUI();
		};

		SpiralCircle();
		virtual ~SpiralCircle();

		virtual bool build( const PatternParamsBase* params );
		virtual std::string getFullName() const;
	};

	class BoustrophedonQuadOrtho : public Pattern
	{
	private:
		float _width;
		float _dist;

		virtual void clear();

		virtual void updateSizeString();

	public:
		class PatternParams : public PatternParamsBase
		{
		public:
			float _width;

			PatternParams() :
				PatternParamsBase(),
				_width( 10 )
			{}

			virtual bool drawUI();
		};

		BoustrophedonQuadOrtho();
		virtual ~BoustrophedonQuadOrtho();

		virtual bool build( const PatternParamsBase* params );
		virtual std::string getFullName() const;
	};

	class BoustrophedonQuadDiag : public Pattern
	{
	private:
		float _width;
		float _dist;

		virtual void clear();

		virtual void updateSizeString();

	public:
		class PatternParams : public PatternParamsBase
		{
		public:
			float _width;

			PatternParams() :
				PatternParamsBase(),
				_width( 10 )
			{}

			virtual bool drawUI();
		};

		BoustrophedonQuadDiag();
		virtual ~BoustrophedonQuadDiag();

		virtual bool build( const PatternParamsBase* params );
		virtual std::string getFullName() const;
	};

	class BoustrophedonQuadDouble : public Pattern
	{
	private:
		float _width;
		float _dist;

		virtual void clear();

		virtual void updateSizeString();

	public:
		class PatternParams : public PatternParamsBase
		{
		public:
			float _width;
			int _jumpMult;

			PatternParams() :
				PatternParamsBase(),
				_width( 10 ),
				_jumpMult( 1 )
			{
				_stitchLength = _dist * _jumpMult;
			}

			virtual bool drawUI();
		};

		explicit BoustrophedonQuadDouble();
		virtual ~BoustrophedonQuadDouble();

		virtual bool build( const PatternParamsBase* params );
		virtual std::string getFullName() const;
	};
}